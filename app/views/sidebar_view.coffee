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
    @on 'channel:change', @resetChannel

  getTemplateData: ->
    current_channel: @current_channel.toJSON()

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

    @render()

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
    mediator.channel = @current_channel
    mediator.storage.set "currentChannel", title

    @trigger('channel:change')

  afterRender: ->
    super
    @setup()
