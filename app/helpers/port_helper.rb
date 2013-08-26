module PortHelper

  def update
    @script = Script.find(params[:id])
    if @script.update_attributes(params[:script])
      flash[:notice] = "Script updated."
      redirect_to(:action => 'show', :id => @script.id)
    else
      @script_count = Script.count
      render('edit')
    end
  end

  def num_systems_by_protocol(name)
    temp = Port.where(:service_protocol => name)
    return temp.count
  end

end
