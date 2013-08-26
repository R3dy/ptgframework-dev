class PortsController < ApplicationController

  layout 'main_layout'

  before_filter :confirm_logged_in

  def index
    accordion
    render('accordion')
  end

  def list
    @ports = Port.order("ports.portnumber ASC")
  end

  def accordion
    @ports = Port.order("ports.service_banner ASC")
    @protocols = Port.select(:service_protocol).map(&:service_protocol).uniq.sort
  end

  def show
    @port = Port.find(params[:id])
  end

  def new
    @port = Port.new(:portnumber => 'default')
    @port_count = Port.count + 1
  end

  def create
    @port = Port.new(params[:port])
    if @port.save
      flash[:notice] = "Port creatd."
      redirect_to(:action => 'list')
    else
      @port_count = Port.count + 1
      render('new')
    end
  end

  def edit
    @port = Port.find(params[:id])
    @port_count = Port.count
  end

  def update
    @port = Port.find(params[:id])
    if @port.update_attributes(params[:port])
      flash[:notice] = "Port updated."
      redirect_to(:action => 'show', :id => @port.id)
    else
      @port_count = Port.count
      render('edit')
    end
  end

  def delete
    @port = Port.find(params[:id])
  end

  def destroy
    Port.find(params[:id]).destroy
    flash[:notice] = "Port destroyted."
    redirect_to(:action => 'list')
  end

end
