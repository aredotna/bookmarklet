View = require 'views/base/view'
DropView = require 'views/drop_view'
ChannelSearchView = require 'views/channel_search_view'
CurrentChannelView = require 'views/current_channel_view'
template = require 'templates/sidebar'
mediator = require 'mediator'


module.exports = class SidebarView extends View
  template: template
  id: "content"
  autoRender: yes

  events:
    'click .close-marklet' : 'closeWindow'

  initialize: (options) ->
    super
    @subscribeEvent 'channel:change', @showCurrentChannel
    @resetChannel()

  resetChannel: ->
    # fail-safe in case channel title is changed
    if mediator.storage.getItem("currentChannel")?
      channel = _.first @collection.where(title: mediator.storage.getItem "currentChannel")

    if channel 
      @setChannel(channel.get('title'))

  setChannel: (title)->
    mediator.channel = _.first @collection.where(title: title)
    mediator.storage.setItem "currentChannel", title

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

      @subview 'drop', new DropView
        model: mediator.channel
        container: "#drop"

      @renderedSubviews = yes

  closeWindow: (e) ->
    mediator.publish 'message:send', action: "close"

