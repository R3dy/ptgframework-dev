class XmlImportController < ApplicationController

  layout 'main_layout'

  def index
    render('import')
  end

  def list
    @hosts = Host.order("hosts.operating_system ASC")
  end

  def process_host(host)
    # Create a new record in the Host database
    newhost = Host.new(:ipv4_address => host.ip4_addr, :hostname => host.hostname, :status => host.status, :reason => host.reason, :operating_system => host.os.name)
    newhost.save
    # For each open port, create a new record in the Port database
    [:tcp, :udp].each do |proto|
      host.getports(proto, "open") do |port|
        process_port(get_host_id(host), port)
        newport = Port.new(:host_id => newhost.id, :port_protocol => port.proto, :state => port.state, :reason => port.reason, :service_protocol => port.service.name, :portnumber => port.num, :service_banner => port.service.product, :service_version => port.service.version, :service_extra_info => port.service.extra)
        newport.save
        if !port.scripts.empty?
          port.scripts.each do |script|
            newscript = Script.new(:port_id => newport.id, :script_name => script.id, :script_output => script.output)
            newscript.save
          end
        end
      end
    end
  end

  def create
    @xml = XmlImport.new
  end

  def uploadFile
    puts params[:upload].inspect
    this = params[:remote_xml_url]
    File.open('temp.xml', 'w') do |file|
      file.write(this.read)
    end
    post = DataFile.save(params[:remote_xml_url])
    render :text => "File has been uploaded successfully"
  end

  def add_scan_data
    puts "hello"
    puts params[:remote_xml_url]
    #puts "There"
    #file = File.open(params[:upload])
    #parser = Nmap::Parser.parsefile(file)
    #parser.hosts("up") do |host|
    #  process_host(host)
    #end
    render("import")
  end

  def process_script(portid, script)
    # method is called from within process_port()
    # used to add NSE script informaiton into the database
    @db.prepare('insert', 'INSERT INTO scripts (port_id, script_name, script_output) values ($1, $2, $3)')
    @db.exec_prepared('insert', [ portid, script.id, script.output ])
    @db.exec('DEALLOCATE insert')
  end

  def process_port(hostid, port)
    # method is called from within process_host()
    # used to add port information to the database
    @db.prepare('insert', 'INSERT INTO ports (host_id, port_protocol, state, reason, service_protocol, portnumber, service_banner, service_version, service_extra_info) values ($1, $2, $3, $4, $5, $6, $7, $8, $9)')
    @db.exec_prepared('insert', [hostid, port.proto, port.state, port.reason, port.service.name, port.num, port.service.product, port.service.version, port.service.extra ])
    @db.exec('DEALLOCATE insert')
    if !port.scripts.empty?
      port.scripts.each do |script|
        process_script(get_port_id(port, hostid), script)
      end
    end
  end

  def get_host_id(host)
    # quick and dirty method to grab a host.id value
    # from the database
    @db.prepare('select1', 'SELECT id FROM hosts WHERE ipv4_address = $1')
    hostid = @db.exec_prepared('select1', [ host.ip4_addr ])
    @db.exec('DEALLOCATE select1')
    return hostid[0]['id'].to_i
  end

  def get_port_id(port, hostid)
    # quick and dirty method to grab a port.id value 
    # from the database
    @db.prepare('select1', 'SELECT id FROM ports WHERE portnumber = $1 AND host_id = $2')
    portid = @db.exec_prepared('select1', [port.num, hostid ])
    @db.exec('DEALLOCATE select1')
    return portid[0]['id'].to_i
  end
 
end
