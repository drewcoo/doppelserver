#!/usr/bin/env ruby
$LOAD_PATH.unshift File.expand_path '../lib', __dir__
require 'rubygems'
require 'doppelserver'
require 'thor'

#
# A command line tool to tell the Doppelserver service controller
# what to do.
#
class ServiceControllerConsole < Thor
  map %w[/? /h] => :help
  map 'up' => :start
  map 'down' => :stop

  DEFAULT_PORT = '7357'.freeze
  class_option :port, default: DEFAULT_PORT, aliases: '-p',
                      desc: 'port service runs on'

  desc 'helper: bail_out!', 'abort with a message', hide: true
  def bail_out!
    message = running? ? 'already' : 'not'
    abort "ERROR #{message} running on port #{options.port}"
  end

  desc 'helper: running?', 'Bool am I running?', hide: true
  def running?
    # memoize this so that we don't call running? twice
    # when we 'bail_out! if runnning?' and we exit this tool after each call
    # so the memoization doesn't hurt x-call
    #
    # I used this, so left it commented in case I need it later:
    # puts defined?(@running) ? 'defined' : 'not defined'
    @running ||= service_controller.running?
  end

  desc 'helper: service controller', 'tell the service what to do', hide: true
  def service_controller
    @service_controller ||= ServiceController.new(options.port)
  end

  #
  # Also hide this method. It's the one that starts the server
  # as the current process. The start method starts a new process
  # invoking this.
  #
  desc 'server', 'do not call directly', hide: true
  def server
    service_controller.serve
  end

  desc 'start', 'start server'
  method_option :data, aliases: '-d',
                       desc: 'text JSON data - remember to escape quotes'
  def start
    bail_out! if running?
    service_controller.start
    set unless options.data.nil?
  end

  desc 'stop', 'stop server'
  method_option :data, aliases: '-d',
                       desc: 'if passed, dumps data to console'
  def stop
    bail_out! unless running?
    data if options.data
    service_controller.stop
  end

  desc 'restart', 'restart server, dumping all data'
  def restart
    bail_out! unless running?
    service_controller.restart
  end

  # Bad data zeroes everything out. Fix that or just doc it in help?
  desc 'data', 'send/retreive all data'
  method_option :set, aliases: '-s',
                      desc: '-s <data> to send JSON; no args to get from server'
  def data
    bail_out! unless running?
    if options.set
      service_controller.set(options.set)
    else
      STDOUT.puts service_controller.get.gsub('"', '\"')
    end
  end
end

ServiceControllerConsole.start
