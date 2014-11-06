=begin
Copyright (c) 2008-2012 Pivotal Labs

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=end

Rake::Task['jasmine:ci'].clear if Rake::Task.task_defined?('jasmine:ci')


namespace :jasmine do
  desc 'Run continuous integration tests'
  task :ci => %w(jasmine:require_json jasmine:require jasmine:configure) do
    config = Jasmine.config

    server = Jasmine::Server.new(config.port(:ci), Jasmine::Application.app(config))
    t = Thread.new do
      begin
        server.start
      rescue ChildProcess::TimeoutError
      end
      # # ignore bad exits
    end
    t.abort_on_exception = true
    Jasmine::wait_for_listener(config.port(:ci), 'jasmine server')
    puts 'jasmine server started.'

    formatters = config.formatters.map { |formatter_class| formatter_class.new }

    exit_code_formatter = Jasmine::Formatters::ExitCode.new
    formatters << exit_code_formatter

    url = "#{config.host}:#{config.port(:ci)}/"
    runner = config.runner.call(Jasmine::Formatters::Multi.new(formatters), url)
    runner.run

    exit exit_code_formatter.exit_code
  end

  task :server => %w(jasmine:require jasmine:configure) do
    config = Jasmine.config
    port = config.port(:server)
    server = Jasmine::Server.new(port, Jasmine::Application.app(Jasmine.config))
    puts "your server is running here: http://localhost:#{port}/"
    puts "your tests are here:         #{config.spec_dir}"
    puts "your source files are here:  #{config.src_dir}"
    puts ''
    server.start
  end
end

desc 'Run specs via server:ci'
task :jasmine => %w(jasmine:server)