class Script < ActiveRecord::Base
  attr_accessible :script_name, :script_output, :port_id, :host_id
  belongs_to :port
  belongs_to :host
end
