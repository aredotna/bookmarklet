View = require 'views/base/view'
DropView = require 'views/drop_view'
template = require 'templates/sidebar'
mediator = require 'mediator'


module.exports = class SidebarView extends View
  template: template
  id: "content"
  autoRender: false

  initialize: (options) ->
    super
    @resetChannel()
    @subscribeEvent 'channel:change', @render
    @render()

  getTemplateData: ->
    current_channel: mediator.channel.toJSON()

  events:
    'click .close' : 'closeWindow'

  closeWindow: (e)->
    window.top.postMessage({action:"close"},"*")

  resetChannel: ->
    # fail-safe in case channel title is changed
    if mediator.storage.get("currentChannel")?
      channel = _.first @collection.where(title: mediator.storage.get "currentChannel")

    if !channel
      channel = _.first @collection.where(title: mediator.user.get('user').username) 

    if !channel 
        channel = @collection.first()

    if channel 
      @setChannel(channel.get('title'))

  setup: ->
    @$('#channel-picker').typeahead
      source: @collection.pluck('title')
      items: 3
      onselect: (title) => @setChannel(title)

    @dropzone?.dispose()
    @dropzone = new DropView(model: mediator.channel)
    @$('#drop').html(@dropzone.render().$el)

  setChannel: (title)->
    mediator.channel = _.first @collection.where(title: title)
    mediator.storage.set "currentChannel", title

    mediator.publish('channel:change')

  afterRender: ->
    super
    @setup()
