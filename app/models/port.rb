class Port < ActiveRecord::Base
  attr_accessible :port_protocol, :portnumber, :service_protocol, :service_banner, :service_version, :service_extra_info, :id, :host_id, :state, :reason
  belongs_to :host
  has_many :scripts
end
