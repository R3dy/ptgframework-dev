class Host < ActiveRecord::Base
  attr_accessible :id, :ipv4_address, :ipv6_address, :hostname, :operating_system, :remote_xml_url, :status, :reason
  has_many :ports
  has_many :scripts, :through => :ports
end
