#
# Like the name suggests, helper methods for pluralization.
#
module PluralizeHelper
  require 'active_support'

  ENFORCE_PLURALS = true

  #
  # Determines if
  # word:: an input word
  # is singular.
  # Retutns truthy.
  #
  def singular?(word)
    ActiveSupport::Inflector.singularize(word) == word
  end

  #
  # If ENFORCE_PLURALS is true (default == true)
  # This enforces plural names for all collections
  # and returns 403 otherwise.
  # word:: collection name
  #
  def enforce_plural(word)
    # Mixing in the contol exclusion is strange here.
    # This can still coexist with a /controls endpoint but may be confusing.
    # I don't want to think about the possibility that we don't have plural
    # collections and happen to have a collision with a control collection yet.
    if word != 'control' && ENFORCE_PLURALS && singular?(word)
      halt 403, 'only plural collection names allowed'
    end
    word
  end
end
