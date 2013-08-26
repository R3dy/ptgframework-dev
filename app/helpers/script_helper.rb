module ScriptHelper

  def num_systems_by_scriptname(name)
    temp = Script.where(:script_name => name)
    return temp.count
  end

end
