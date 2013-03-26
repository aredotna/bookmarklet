View = require 'views/base/view'
mediator = require 'mediator'
Item = require 'models/item'
ItemView = require 'views/item_view'
config = require 'config'


module.exports = class DropView extends View
  id: 'drop-content'
  
  events:
    "click .block-close" : "reset"

  initialize: (options) ->
    super
    @delegate 'click', '.block-close', @reset
    @delegate 'click', '.save-as-page-link', @postLink
    @delegate 'click', '.status-container', @forceReset
    @subscribeEvent 'drop', @handleDrop

  postLink: ->
    data =
      source: mediator.source.url || document.referrer
      type: "Block"
    
    @createBlock(data)
    #Bookmarklet.metrics.trigger('bookmark', "Block", 'Save page')

  handleDrop: (data, a, b) ->
    $html = $(data.value['text/html'])
    src   = $html.find('img').attr('src')
    src   = $html.first().next().attr('src')  if not src
    src   = $html.first().next().attr('href') if not src
    
    type = if src then "Block" else "Text"

    if type is "Text"
      data =
        content: data.value['text/plain']
    else
      $value = $(data.value['text/html'])
      imgsrc = $value.find('img').attr('src')
      data   =
        source: src

    data.type = type

    mediator.publish 'block:created', {type: type}
    @createBlock(data)
    
  setLoading: ->   @$el.addClass('loading')
  unsetLoading: -> @$el.removeClass('loading')

  createBlock: (data) ->
    return @blockCreationFailed("Please select a channel to add to") unless mediator.channel

    item = new Item(data.block)
    item.set('type', data.type)

    itemview = new ItemView(model: item)
    @$('#item-container').append(itemview.render().$el)
    # itemview.runProgressBar()

    @setLoading()
    
    $.ajax
      type: 'POST'
      url: "#{config.api.versionRoot}/channels/#{mediator.channel.get('slug')}/blocks"
      data: data
      success: (data)=>
        @blockCreated(data, item)
      error: =>
        @blockCreationFailed()

  blockCreated:(data, item) =>
    item.set(data)
    item.setURL()
    @unsetLoading()

    @$('.view-on-arena-link').attr('href', item.get('url'))
    @$el.addClass('complete success').removeClass('ready')
    @timedReset()

  blockCreationFailed: (message)=>
    @unsetLoading()
    message ||= "Failed to create block"
    @$('.status-error').html(message)
    @$el.addClass('complete error').removeClass('ready')
    @timedReset()
    
  render: =>
    @$el.html @template(@model?.toJSON())
    return this

  timedReset: =>
    @resetTimer = window.setTimeout =>
      @reset()
    , 3000

  forceReset: (e)->
    return if $(e.currentTarget).is('a')

    clearTimeout @resetTimer
    @reset()

  reset: ->
    @$el.addClass('ready').removeClass('complete success error')
