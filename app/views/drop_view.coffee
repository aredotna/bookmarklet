View = require 'views/base/view'
template = require 'templates/drop'
mediator = require 'mediator'

module.exports = class DropView extends View
  template: template
  id: 'drop-content'

  initialize: (options) ->
    @subscribeEvent 'drop', @handleDrop

  events:
    "click .page-scrape" : "postLink"

  postLink: ->
    data = block:
      remote_source_url: document.referrer

    #Bookmarklet.metrics.trigger('bookmark', "Block", 'Save page')
    @createBlock(data, "Block")

  handleDrop: (data) ->
    $html = $(data.value['text/html'])
    src   = $html.find('img').attr('src')
    src   = $html.first().next().attr('src')  if not src
    src   = $html.first().next().attr('href') if not src
    
    type = if src then "Block" else "Text"

    if type is "Text"
      data = block:
        content: data.value['text/plain']
    else
      $value = $(data.value['text/html'])
      imgsrc = $value.find('img').attr('src')
      data   = block:
        remote_source_url: src

    #Bookmarklet.metrics.trigger('bookmark', type, 'Drop item')
    @createBlock(data, type)
    
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
      success: (data) =>
        item.set(data)
        item.setURL()
        @unsetLoading()

  render: =>
    @$el.html @template(@model.toJSON())

    return this