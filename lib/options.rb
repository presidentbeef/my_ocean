require 'optparse'

class Options
  def self.parse tool, args
    options = {}

    OptionParser.new do |opts|
      opts.banner = "Usage: #{tool} [options] [image name]"

      opts.on "-s", "--size SIZE", "Set droplet size" do |size|
        options[:size] = size
      end

      opts.on "-r", "--region REGION", Integer, "Set droplet region" do |region|
        options[:region] = region
      end
    end.parse! args

    raise OptionParser::InvalidArgument, "Please supply name of image" if args.empty?
    options[:name] = args.pop

    options
  end
end
