View = require 'views/base/view'
template = require 'templates/drop'
mediator = require 'mediator'
Item = require 'models/item'
ItemView = require 'views/item_view'
config = require 'config'


module.exports = class DropView extends View
  template: template
  id: 'drop-content'
  autoRender: yes
  
  events:
    "click .page-scrape" : "postLink"
    "click .block-close" : "reset"

  initialize: (options) ->
    super
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
    
  setLoading: ->   @$('#drop-zone').addClass('loading')
  unsetLoading: -> @$('#drop-zone').removeClass('loading')

  createBlock: (data) ->
    item = new Item(data.block)
    item.set('type', data.type)

    itemview = new ItemView(model: item)
    @$('#item-container').append(itemview.render().$el)
    itemview.runProgressBar()

    @setLoading()
    
    $.ajax
      type: 'POST'
      url: "#{config.api.versionRoot}/channels/#{mediator.channel.id}/blocks"
      data: data
      success: (data)=>
        @blockCreated(data, item)
      error: @blockCreationFailed

  blockCreated:(data, item) =>
    item.set(data)
    item.setURL()
    @unsetLoading()
    @$('.block-status').html('Block created')
    @$('.block-link').attr('href', item.get('url'))
    @$('#drop-zone').addClass('success').removeClass('loading error')
    @timedReset()

  blockCreationFailed: =>
    @$('.block-status').html('Could not create block')
    @$('#drop-zone').addClass('error').removeClass('loading success')
    @timedReset()
    
  render: =>
    @$el.html @template(@model?.toJSON())
    return this

  timedReset: =>
    window.setTimeout =>
      @reset()
    , 2000

  reset: ->
    @$('#drop-zone').removeClass('success loading error');
