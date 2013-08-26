require 'fileutils'
require 'timeout'
class HttpController < ApplicationController

  layout 'main_layout'

  def index
    accordion
    @webservers.each { |webserver| get_screenshot(webserver) }
    render "accordion"
  end

  def accordion
    @webservers = Array.new
    @threads = Array.new
    @threadcount = 0
    Port.all.each { |port| @webservers << port if port.service_protocol.include?("http") }
    @proto = Array.new
    @webservers.each { |web| @proto << web.service_protocol }
    @proto = @proto.uniq.sort
  end

  def get_screenshot(webserver)
    if @threadcount > 20
      @threads.each { |e| e.join }
    end
    @threads << Thread.new {
      @threadcount = @threadcount + 1
      begin
        timeout(20) do
          site = IMGKit.new(geturl(webserver), :quality => 78, :width => 800, :height => 600)
          if image = site.to_png
            screenshot = File.new("public/screenshots/screenshot-#{Random.rand(100000..999999)}-#{Time.now}.png", "wb")
            screenshot.write(image)
            screenshot.close
          end
        end
      rescue Timeout::Error
        puts "Request timed out"
      rescue => screen_shot_error
        puts "Could not grab screenshot #{screen_shot_error}"
      end
    }
  end

  def geturl(port)
    port.service_protocol = "https" if port.portnumber.to_s.include?("443")
    url = "#{port.service_protocol.to_s}://#{port.host.ipv4_address.to_s}:#{port.portnumber}"
    puts url
    return url
  end

end
