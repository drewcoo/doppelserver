$LOAD_PATH.unshift File.expand_path('..', __dir__)
require 'doppelserver/base_server'
require 'faraday'
require 'json'

#
# Contains the commands to tell the service what to do.
# All of the command line parsing and such is in a /bin/ that I haven't
# decided what to name yet.
#
class ServiceController
  SERVER = 'http://127.0.0.1'.freeze

  attr_reader :port

  def initialize(port)
    @port = port
  end

  def start
    command = "ruby #{__FILE__} server #{@port}"
    command = if ENV['OS'] == 'Windows_NT'
                "start /MIN \"doppelserver\" cmd /c #{command}"
              else
                "nohup #{command} &"
              end
    system command
    sleep 0.1 until running?
  end

  def serve
    system "title doppelserver - port #{@port}" if ENV['OS'] == 'Windows_NT'
    server = Doppelserver::BaseServer
    server.port = @port
    server.run!
  end

  # rubocop:disable Lint/HandleExceptions
  def stop
    return unless running?
    Faraday.delete "#{SERVER}:#{@port}/control"
  rescue Faraday::ConnectionFailed
    # return 0
  end
  # rubocop:enable Lint/HandleExceptions

  def restart
    stop
    start
  end

  def running?
    response = Faraday.get "#{SERVER}:#{@port}/control"
    JSON.parse(response.body)['status'] == 'running'
  rescue Faraday::ConnectionFailed
    false
  end

  def get
    response = Faraday.get "#{SERVER}:#{@port}/control/data"
    response.body
  end

  def set(data)
    Faraday.post "#{SERVER}:#{@port}/control/data", data
  end
end

#
# If this, then turn this process into a runnning service.
#
if $PROGRAM_NAME == __FILE__ && ARGV[0] == 'server'
  server = ServiceController.new(ARGV[1])
  server.serve
end
