View = require 'views/base/view'
DropView = require 'views/drop_view'
ChannelSearchView = require 'views/channel_search_view'
CurrentChannelView = require 'views/current_channel_view'
Channel = require 'models/channel'
template = require 'templates/sidebar'
mediator = require 'mediator'


module.exports = class BookmarkletView extends View
  template: template
  id: "content"
  autoRender: yes

  initialize: (options) ->
    super
    @delegate 'click', '.close-marklet', @closeWindow
    @subscribeEvent 'channel:activate', @setChannel
    @subscribeEvent 'channel:change', @showCurrentChannel
    @resetChannel()

  resetChannel: ->
    # fail-safe in case channel title is changed
    if mediator.storage.getItem("currentChannel")?
      try 
        channel = new Channel JSON.parse(mediator.storage.getItem "currentChannel")
        @setChannel(channel)
      catch e
        console.log e

  setChannel: (channel)->
    mediator.channel = channel
    mediator.storage.setItem "currentChannel", JSON.stringify(channel.toJSON())

    mediator.publish('channel:change')

  showCurrentChannel: ->
    @subview 'current', new CurrentChannelView
      model: mediator.channel

  getTemplateData: ->
    current_channel: mediator.channel?.toJSON()

  afterRender: ->
    super
    @renderSubviews()

  renderSubviews: ->
    unless @renderedSubviews

      @subview 'current', new CurrentChannelView
        model: mediator.channel

      @subview 'search', new ChannelSearchView
        collection: @collection
        el: @$('.search-container')

      @subview 'drop', new DropView
        model: mediator.channel
        el: @$('.drop-zone-container')

      @renderedSubviews = yes

  closeWindow: (e) ->
    mediator.publish 'message:send', action: "close"

