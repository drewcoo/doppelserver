#
# Capture helper - regexen.
#
module CaptureHelper
  # Seems evil but it works. :-(
  # these do pattern matching.
  # They parse out what they say they do while allowing ANY prefix.
  # So http://localhost/v3/myserver/route/id works just like
  #    http://localhost/route/id
  #
  # Because this seems wrong, I'm leaving it notably ugly so that I'll notice
  # and maybe improve it later.
  #
  MATCH_NONSLASH = %r{([^/]+)}
  MATCH_NUMBER = %r{(\d+)}
  # These start with optional everythingm followed bu slash-separated matches
  COLLECTION_ONLY = %r{.*/#{MATCH_NONSLASH}/?} # possible trailing slash
  COLLECTION_AND_ID = %r{.*/#{MATCH_NONSLASH}/#{MATCH_NUMBER}}
end
