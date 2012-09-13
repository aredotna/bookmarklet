Controller = require 'controllers/base/controller'
ChannelCollection = require 'models/channel_collection'
SidebarView = require 'views/sidebar_view'

module.exports = class BookmarkletController extends Controller

  initialize: ->
    @model = new ChannelCollection
    @view = new SidebarView
      collection: @model