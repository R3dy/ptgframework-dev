require 'fileutils'

class XmlsController < ApplicationController 

    def index
        @xmls = Xml.all

        respond_to do |format|
            format.html
            format.json { render json: @xmls }
        end
    end

    def new
        @xml = Xml.new

        respond_to do |format|
            format.html
            format.json { render json: @xml }
        end
    end

    def edit
        @xml = Xml.find(params[:id])
    end

    def create
      parser = Nmap::Parser.parsefile(params[:xml][:file].tempfile)
      parser.hosts("up") do |host|
        process_host(host)
      end
      flash[:notice] = "Uploaded new records to the database!"
      redirect_to :controller => "hosts"
    end

    def check_null(name)
      if name == nil
        return "unknown"
      else
        return name
      end
    end

    def process_host(host)
      recordhash = {:ipv4_address => host.ip4_addr,
                    :hostname => host.hostname,
                    :status => host.status,
                    :reason => host.reason,
                    :operating_system => check_null(host.os.name)
      }
      newhost = Host.new(recordhash)
      newhost.save
      # For each open port, create a new record in the Port database
      [:tcp, :udp].each do |proto|
        host.getports(proto, "open") do |port|
          newhost.has_open_ports = true unless newhost.has_open_ports == true
          process_port(newhost, port)
        end
      end
    end

    def process_port(host, port)
      recordhash = { :host_id => host.id,
                     :port_protocol => port.proto,
                     :state => port.state,
                     :reason => port.reason,
                     :service_protocol => check_null(port.service.name),
                     :portnumber => port.num,
                     :service_banner => port.service.product,
                     :service_version => port.service.version,
                     :service_extra_info => port.service.extra
      }
      newport = Port.new(recordhash)
      newport.save
      unless port.scripts.empty?
        host.has_nse = true
        host.save
        port.scripts.each { |script|
          process_script(host.id, newport.id, script)
        }
      end
    end

    def process_script(hostid, portid, script)
      puts script.inspect
      recordhash = {:port_id => portid,
                    :host_id => hostid,
                    :script_name => check_null(script.id),
                    :script_output => script.output
      }
      newscript = Script.new(recordhash)
      newscript.save
    end

    def update
        @xml = Xml.find(params[:id])

        respond_to do |format|
            if @xml.update_attributes(params[:upload])
                format.html { redirect_to @xml, notice: 'Upload was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: "edit" }
                format.json { render json: @xml.errors, status: :unprocessable_entity }
            end
        end
    end

    def show
        @xml = Xml.find(params[:id])


        respond_to do |format|
            format.html # show.html.erb
            format.json { render json: @xml }
        end 
    end

end
