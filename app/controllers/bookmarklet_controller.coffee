Controller = require 'controllers/base/controller'
ChannelCollection = require 'models/channel_collection'
Channel = require 'models/channel'
BookmarkletView = require 'views/bookmarklet_view'
mediator = require 'mediator'
config = require 'config'

module.exports = class BookmarkletController extends Controller

  initialize: ->
    super
    @start()

  start: ->
    @subscribeEvent 'login', @showInterface
    @subscribeEvent 'action:newChannel', @newChannel

  showInterface: ->
    @view = new BookmarkletView
      collection: new ChannelCollection
      container: $('.bookmarklet-content')

  newChannel: (attributes) ->
    @model = new Channel attributes

    $('#channel-picker').addClass('loading')

    # true is true
    @model.save {true: true},
      wait: true
      success: (model) =>
        link = new Channel(model.attributes)
        mediator.user.get('links').unshift(link)
        $('#channel-picker').removeClass('loading').val('')
        mediator.publish "channel:activate", link