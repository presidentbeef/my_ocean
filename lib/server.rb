require 'digital_ocean'
require_relative '../config/keys'

class Server
  def initialize name, opts = {}
    @ocean = DigitalOcean::API.new :client_id => CLIENT_ID, :api_key => API_KEY
    @name = name
    @size = opts[:size] || "2GB"
    @region_id = opts[:region] || 1
    get_server
  end

  def save_and_destroy
    shutdown
    snapshot
    shutdown
    destroy
  end

  def restore
    if @server
      abort "Droplet '#@name' already exists"
    end

    size = @ocean.sizes.list.sizes.find { |s| s.name == @size }

    if size.nil?
      abort "Cannot find right size!"
    end

    image = latest_image

    if image.nil?
      abort "Cannot find right image!"
    end

    puts "Restoring #{image.inspect}"

    opts = {:name => @name, :size_id => size.id, :image_id => image.id, :region_id => @region_id}

    res = @ocean.droplets.create(opts)

    if res[:status] != "OK"
      abort res
    end

    until status == "active"
      puts "Waiting on droplet creation..."
      sleep 30
    end

    get_server

    puts "Now at #{@server.ip_address}"

    remove_old_images
  end


  def get_server
    @server ||= @ocean.droplets.list.droplets.find { |d| d.name == @name }
  end

  def droplet action, opts = nil
    get_server

    if @server
      if opts
        @ocean.droplets.send(action, @server.id, opts)
      else
        @ocean.droplets.send(action, @server.id)
      end
    else
      abort "No server '#@name' to be found..."
    end
  end

  def shutdown
    puts "Shutting down"
    p droplet(:shutdown)
  end

  def startup
    droplet :power_on

    until active?
      puts "Waiting for startup..."
      sleep 4
    end
  end

  def snapshot
    until off?
      puts "Waiting for shutdown... #{status.inspect}"
      sleep 4
    end

    puts "Snapshot!"
    last_snapshot = "#@name-auto #{Time.now.to_i}"
    until droplet(:snapshot, :name => last_snapshot).status == "OK"
      puts "Waiting for previous action to complete..."
      sleep 4
    end

    until image = @ocean.images.list.images.find { |i| i.name == last_snapshot }
      puts "Waiting for snapshot to complete..."
      sleep 30
    end
  end

  def destroy
    until off?
      puts "Waiting for shutdown... #{status.inspect}"
      sleep 4
    end

    sleep 10 #wait for VNC to be disabled

    until droplet(:delete).status == "OK"
      puts "Trying to delete..."
      sleep 5
    end
  end

  def remove_old_images
    current_images = @ocean.images.list(:filter => "my_images").images.select { |i| i.name =~ /^#@name-auto/ }

    if current_images.length > 2
      oldest = current_images.sort_by { |i| i.name.split[1].to_i }[0..-3]

      oldest.each do |i|
        @ocean.images.delete(i.id)
        puts "Deleted #{i.name}"
      end
    end
  end

  def latest_image
    @ocean.images.list(:filter => "my_images").images.select do |i|
      i.name =~ /^#@name-auto/
    end.sort_by do |i|
        i.name.split[1].to_i
    end.last
  end

  def status
    droplet(:show).droplet.status
  end

  def active?
    status == "active"
  end

  def off?
    status == "off"
  end
end
