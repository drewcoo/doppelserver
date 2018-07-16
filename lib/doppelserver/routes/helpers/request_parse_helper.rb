require 'doppelserver/routes/helpers/pluralize_helper'
#
# Helper methods for web request parsing.
#
module RequestParseHelper
  include PluralizeHelper
  #
  # Parses parameters and checks that collections are plural if needed.
  #
  def parse_params(params)
    collection, id = params['captures']
    enforce_plural(collection)
    id ? [collection, id] : collection
  end

  #
  # Also for non-POST, callers ask to check the collection against
  # known collections and 404 if asking for an unknown one
  #
  def check_exists(collection, data)
    halt 404 unless data.collection?(collection)
  end

  #
  # Takes a request body and returns post data.
  # Unless is errors out because of no data or a parse error.
  #
  def read_post_data(body)
    raw_data = body.read
    halt 403, 'NO DATA' if raw_data.empty?
    begin
      JSON.parse(raw_data)
    rescue JSON::ParserError
      halt 403, "BAD DATA:\n#{raw_data}"
    end
  end
end
