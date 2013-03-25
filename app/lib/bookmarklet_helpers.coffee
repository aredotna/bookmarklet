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

Handlebars.registerHelper 'if_channel', (string, options) ->
  str = Handlebars.helpers.downcase(string)
  if str is "channel" then options.fn this else options.inverse this

Handlebars.registerHelper 'if_block', (string, options) ->
  str = Handlebars.helpers.downcase(string)
  if str is "block"
    options.fn this
  else
    options.inverse this

Handlebars.registerHelper 'size', (collection) ->
  collection.length

Handlebars.registerHelper 'render_markdown', (content, options) ->
  if content
    new Markdown.getSanitizingConverter().makeHtml(content)

Handlebars.registerHelper 'snippet', (content) ->
  content?.replace(/<.*?>/g, ' ').truncate(230)

Handlebars.registerHelper 'markdown_snippet', (content, length) ->
  _html = Handlebars.helpers.render_markdown(content)
  $.truncate(_html, { length: length, noBreaks: false, lightFormatting: true })


Handlebars.registerHelper 'downcase', (content) ->
  content?.toLowerCase()

Handlebars.registerHelper 'truncate', (content, length) ->
  content?.truncate(length)

Handlebars.registerHelper 'pluralize', (content, length, plural = null) ->
  content?.pluralize(length, plural)

Handlebars.registerHelper 'unless_equals', (thing, other_thing, options) ->
  unless thing is other_thing
    options.fn this
  else
    options.inverse this

Handlebars.registerHelper 'if_equals', (thing, other_thing, options) ->
  if thing is other_thing
    options.fn this
  else
    options.inverse this

Handlebars.registerHelper "if_empty", (collection, options) ->
  if collection.length < 0
    options.fn this
  else
    options.inverse this

Handlebars.registerHelper "unless_empty", (collection, options) ->
  if collection.length > 0
    options.fn this
  else
    options.inverse this

Handlebars.registerHelper 'is_in_set', (object, set, options) ->
  if object in set
    options.fn this
  else
    options.inverse this

Handlebars.registerHelper "debug", (optionalValue) -> 
  console.log("Current Context")
  console.log("====================")
  console.log(this)

  if optionalValue
    console.log("Value")
    console.log("====================")
    console.log(optionalValue)

Handlebars.registerHelper "partial", (name, opts) ->
  Handlebars.registerPartial name, opts.fn

Handlebars.registerHelper "recent_time_ago", (string, time, opts) ->
  "#{string} #{moment(time).fromNow()}"

Handlebars.registerHelper "time_ago", (time, opts) ->
  moment(time).fromNow()

Handlebars.registerHelper "pretty_time", (time, opts) ->
  moment(time).fromNow()

Handlebars.registerHelper "initials", (string, opts) ->
  splitName = string?.split(" ")
  if splitName?
    initials = for name in splitName
      name?.substring(0, 1)
    initials.join("").substring(0,4) # Limit initials to 4 characters

Handlebars.registerHelper "initials_first_and_last", (stringA, stringB, opts) ->
  stringA.substring(0, 1) + stringB.substring(0, 1)

Handlebars.registerHelper "if_greater_than_one", (collection, opts) ->
  if collection.length > 1
    opts.fn this
  else
    opts.inverse this

Handlebars.registerHelper "collection_if_greater_than_zero", (collection, opts) ->
  if collection.length > 0
    opts.fn this
  else
    opts.inverse this

Handlebars.registerHelper "collection_if_greater_than_one", (collection, opts) ->
  if collection.length > 1
    opts.fn this
  else
    opts.inverse this

Handlebars.registerHelper "value_if_greater_than_zero", (value, opts) ->
  if value > 0
    opts.fn this
  else
    opts.inverse this

Handlebars.registerHelper "value_if_greater_than_one", (value, opts) ->
  if value > 1
    opts.fn this
  else
    opts.inverse this

Handlebars.registerHelper "if_can", (permissions, ability, opts) ->
  if _.include(permissions, ability) then opts.fn(this) else opts.inverse(this)

Handlebars.registerHelper "when_cant", (permissions, ability, opts) ->
  unless _.include(permissions, ability) then opts.fn(this) else opts.inverse(this)

String.prototype.truncate = (length)->
  if this.length > length
    return this.slice(0, length - 3) + "..."
  else
    return this
String.prototype.capitalize = ->
    return this.charAt(0).toUpperCase() + this.slice(1)

String.prototype.pluralize = (count) ->
  pluralized = if count is 1 then this else this + 's' 
  return pluralized
