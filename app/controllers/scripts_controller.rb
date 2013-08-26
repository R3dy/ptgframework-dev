class ScriptsController < ApplicationController
      
  layout 'main_layout'

  before_filter :confirm_logged_in

  def index
    accordion
    render('accordion')
  end

  def list
    @scripts = Script.order("scripts.script_name ASC")
  end

  def accordion
    @scripts = Script.order("scripts.script_output ASC")
    @nsescripts = Script.select(:script_name).map(&:script_name).uniq.sort
  end

  def show
    @script = Script.find(params[:id])
  end

  def new
    @script = Script.new(:script_name => 'default')
    @script_count = Script.count + 1
  end

  def create
    @script = Script.new(params[:script])
    if @script.save
      flash[:notice] = "Script creatd."
      redirect_to(:action => 'list')
    else
      @script_count = Script.count + 1
      render('new')
    end
  end

  def edit
    @script = Script.find(params[:id])
    @script_count = Script.count
  end


  def delete
    @script = Script.find(params[:id])
  end

  def destroy
    Script.find(params[:id]).destroy
    flash[:notice] = "Script destroyted."
    redirect_to(:action => 'list')
  end
end
