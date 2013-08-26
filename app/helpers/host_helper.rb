module HostHelper
  def num_systems_by_osname(osname)
    temp = Host.where(:operating_system => osname)
    return temp.count
  end
end
