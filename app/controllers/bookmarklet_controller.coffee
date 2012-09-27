Controller = require 'controllers/base/controller'
ChannelCollection = require 'models/channel_collection'
SidebarView = require 'views/sidebar_view'

module.exports = class BookmarkletController extends Controller

  initialize: ->
    super
    @start()

  start: ->
    console.log 'home'
    @subscribeEvent 'login', @showInterface

  showInterface: ->
    console.log 'should be showing showInterface'
    @model = new ChannelCollection
    @view = new SidebarView
      collection: @model
      container: $('.bookmarklet-content')