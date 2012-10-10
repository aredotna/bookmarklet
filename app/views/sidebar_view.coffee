View = require 'views/base/view'
DropView = require 'views/drop_view'
template = require 'templates/sidebar'
mediator = require 'mediator'


module.exports = class SidebarView extends View
  template: template
  id: "content"
  autoRender: yes

  events:
    'click .close' : 'closeWindow'

  initialize: (options) ->
    super
    @resetChannel()
    @subscribeEvent 'channel:change', @render

  setChannel: (title)->
    mediator.channel = _.first @collection.where(title: title)
    mediator.storage.setItem "currentChannel", title

    mediator.publish('channel:change')

  resetChannel: ->
    # fail-safe in case channel title is changed
    if mediator.storage.getItem("currentChannel")?
      channel = _.first @collection.where(title: mediator.storage.getItem "currentChannel")

    if !channel
      channel = _.first @collection.where(title: mediator.user.get('user').username) 

    if !channel 
        channel = @collection.first()

    if channel 
      @setChannel(channel.get('title'))

  getTemplateData: ->
    current_channel: mediator.channel.toJSON()

  afterRender: ->
    super
    @renderSubviews()

  renderSubviews: ->
    unless @renderedSubviews
      @subview 'search', new ChannelSearchView
        container: ".channelsearch-container"

      @subview 'drop', new DropView
        model: mediator.channel
        container: "#drop"

  closeWindow: (e) ->
    mediator.publish 'message:send', action: "close"

