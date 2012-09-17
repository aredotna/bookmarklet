Controller = require 'controllers/base/controller'
ChannelCollection = require 'models/channel_collection'
SidebarView = require 'views/sidebar_view'

module.exports = class BookmarkletController extends Controller

  home: ->
    @subscribeEvent 'login', @showInterface

  showInterface: ->
    @model = new ChannelCollection
    @view = new SidebarView
      collection: @model
      container: $('.bookmarklet-content')