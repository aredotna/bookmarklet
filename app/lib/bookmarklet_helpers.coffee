Handlebars.registerHelper 'downcase', (content) ->
  content?.toLowerCase()

Handlebars.registerHelper "get_state", (published, open) ->
  if published is false
    'Private'
  else if open is false
    'Closed'
  else
    'Public'

Handlebars.registerHelper "get_state_lowercase", (published, open) ->
  Handlebars.helpers.downcase(Handlebars.helpers.get_state(published, open))

Handlebars.registerHelper 'if_profile', (channel, options) ->
  if @kind is "profile" then options.fn(this) else options.inverse(this)