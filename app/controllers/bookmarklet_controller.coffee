Controller = require 'controllers/base/controller'
ChannelCollection = require 'models/channel_collection'
Channel = require 'models/channel'
SidebarView = require 'views/sidebar_view'
mediator = require 'mediator'

module.exports = class BookmarkletController extends Controller

  initialize: ->
    super
    @start()

  start: ->
    @subscribeEvent 'login', @showInterface

  showInterface: ->
    @view = new SidebarView
      collection: mediator.user.get 'links'
      container: $('.bookmarklet-content')

  newChannel: (attributes) ->
    @model = new Channel attributes

    $('#q').addClass('loading')

    # true is true
    @model.save {true: true},
      wait:true
      success: (model) =>
        link = new Link(model.attributes)
        mediator.user.get('channels').unshift(link)
        $('#q').removeClass('loading').val('')
        mediator.publish 'sidebar:filter', value: ''
        @redirectTo "/#{model.get('slug')}"
      error: ->
        console.log 'erro?'