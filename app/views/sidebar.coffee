View = require 'views/base/view'
DropView = require 'views/drop'
template = require 'templates/sidebar'
mediator = require 'mediator'



class SidebarView extends View
  template: template
  id: "content"

  initialize: (options) ->
    @resetChannel()
    @on 'channel:change', @render

  events:
    'click .close' : 'closeWindow'

  closeWindow: (e)->
    window.top.postMessage({action:"close"},"*")

  resetChannel: ->
    # fail-safe in case channel title is changed
    if localStorage["currentChannel"]?
      channel = _.first @collection.where(title: localStorage["currentChannel"])
    channel = _.first @collection.where(title: mediator.user.get('username')) if not channel?

    @setChannel(channel.get('title'))

  setup: ->
    @$('#channel-picker').typeahead
      source: @collection.pluck('title')
      items: 3
      onselect: (title) => @setChannel(title)

    @dropzone?.dispose()
    @dropzone = new DropView(model: @current_channel)
    @$('#drop').html(@dropzone.render().$el)

  setChannel: (title)->
    @current_channel = _.first @collection.where(title: title)
    localStorage["currentChannel"] = title
    @trigger('channel:change')

  render: =>
    @$el.html @template
      channels: @collection
      current_channel: @current_channel.toJSON()
    
    @setup()

    return this