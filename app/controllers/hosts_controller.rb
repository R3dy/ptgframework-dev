class HostsController < ApplicationController

  layout 'main_layout'

  before_filter :confirm_logged_in

  def index
    accordion
    render('accordion')
  end

  def list
    @hosts = Host.order("hosts.operating_system ASC")
  end

  def accordion
    @hosts = Host.order("hosts.operating_system ASC")
    @operatingsystems = Host.select(:operating_system).map(&:operating_system).uniq.sort
  end

  def show
    @host = Host.find(params[:id])
    @ports = Port.where(:host_id => @host.id).order("service_protocol DESC")
    if @host.has_nse == true
      @scripts = Script.where(:host_id => @host.id)
    end
  end

  def new
    @host = Host.new(:ipv4_address => 'default')
    @host_count = Host.count + 1
  end

  def create
    @host = Host.new(params[:host])
    if @host.save
      flash[:notice] = "Host creatd."
      redirect_to(:action => 'list')
    else
      @host_count = Host.count + 1
      @subject_count = Subject.count
      render('new')
    end
  end

  def edit
    @host = Host.find(params[:id])
    @host_count = Host.count
  end

  def update
    @host = Host.find(params[:id])
    if @host.update_attributes(params[:host])
      flash[:notice] = "Host updated."
      redirect_to(:action => 'show', :id => @host.id)
    else
      @host_count = Host.count
      @subject_count = Subject.count
      render('edit')
    end
  end

  def delete
    @host = Host.find(params[:id])
  end

  def destroy
    Host.find(params[:id]).destroy
    flash[:notice] = "Host destroyted."
    redirect_to(:action => 'list')
  end

end
