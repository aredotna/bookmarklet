Chaplin = require 'chaplin'
mediator = require 'mediator'
routes = require 'routes'
SessionController = require 'controllers/session_controller'
Storage = require 'models/storage'
Layout = require 'views/layout'

module.exports = class Application extends Chaplin.Application
  title: 'Arena Bookmarklet'

  initialize: ->
    super

    @initDispatcher()
    @initLayout()
    @initMediator()

    @initControllers()

    @initRouter routes
    Object.freeze? this


  initLayout: ->
    @layout = new Layout {@title}


  initControllers: ->
    new SessionController()

  initMediator: ->
    Chaplin.mediator.user = null
    Chaplin.mediator.channel = null
    Chaplin.mediator.storage = new Storage
    Chaplin.mediator.seal()
