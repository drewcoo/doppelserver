require 'sinatra'
require 'doppelserver/data'
# Most of the BaseServer class is in the routes below:
require 'doppelserver/routes/control'
require 'doppelserver/routes/rest'

module Doppelserver
  class BaseServer < Sinatra::Base
    #
    # Hold all of the data internally in the @@data.
    # It's the Data class, which holds a hash of data and
    # another of next keys. (???)
    #
    configure do
      @@data = Data.new
    end

    run! if app_file == $PROGRAM_NAME
  end
end
