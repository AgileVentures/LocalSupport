#Use this file to set/override Jasmine configuration options
#You can remove it if you don't need it.
#This file is loaded *after* jasmine.yml is interpreted.
#
#Example: using a different boot file.
#Jasmine.configure do |config|
# @config.boot_dir = '/absolute/path/to/boot_dir'
# @config.boot_files = lambda { ['/absolute/path/to/boot_dir/file.js'] }
#end
#

# Without this, WebMock blocks "rake jasmine:ci" for travis
module Jasmine
  class Config
    require 'webmock'
    WebMock.allow_net_connect!
  end
end

# So that phantomJS doesn't error out when faced with a browser console error message
module Jasmine
  module Runners
    class PhantomJs
      def run
        command = "#{Phantomjs.path} '#{File.join(File.dirname(__FILE__), 'phantom_jasmine_run.js')}' #{jasmine_server_url} #{result_batch_size}"
        IO.popen(command) do |output|
          output.each do |line|
            begin
              raw_results = JSON.parse(line, :max_nesting => false)
              results = raw_results.map { |r| Result.new(r) }
              formatter.format(results)
            rescue => e
              puts "Warning: #{e}"
            end
          end
        end
        formatter.done
      end
    end
  end
end