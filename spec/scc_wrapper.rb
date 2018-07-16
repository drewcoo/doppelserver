SCC_PATH = File.expand_path('../bin/scc.rb', __dir__)

require 'open3'

#
# A class to wrap scc.rb for test purposes.
# It does ugly things.
#
class SCCWrapper
  attr_accessor :stdout, :stderr, :status

  def call(string)
    @stdout = @stderr = ''
    command = "ruby #{SCC_PATH} #{string}"
    # We don't get STDOUT or STDERR for start because we don't want to
    # hang waiting for exit if we Open3.*.
    # To conform with the Open3 calls, convert the bool response to integer.
    # In case not all future calls come through method_missing, match / start/.
    # Also we need to catch the superset of all starts and call with system, so
    # that's restart, too.
    # BUG: This currently spews restart failure errors.
    if command =~ /start/
      @status = system(command) ? 0 : 1
    else
      @stdout, @stderr, @status = Open3.capture3(command)
    end
    @status == 0
  end

  def method_missing(method, *args)
    name = method.to_s
    super unless respond_to_missing? name
    call args.empty? ? name : "#{name} #{args.join(' ')}"
  end

  def respond_to_missing?(method)
    %w[data server start stop restart running?].include? method
  end
end
