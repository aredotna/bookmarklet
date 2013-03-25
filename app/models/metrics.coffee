Model = require 'models/base/model'
mediator = require 'mediator'

module.exports = class Metrics extends Model

  initialize: ->
    super

    @subscribeEvent 'login', @login
    @subscribeEvent 'channel:activate', @changeChannel
    @subscribeEvent 'block:created', @blockCreated

  login: ->
    mixpanel.identify mediator.user.id
    
    mixpanel.people.identify mediator.user.id

    mixpanel.people.set
      id: mediator.user.id
      $email: mediator.user.get 'email' 
      $first_name: mediator.user.get 'first_name'
      $last_name: mediator.user.get 'last_name'
      $name: mediator.user.get 'username'
      $last_login: new Date()

    mixpanel.name_tag mediator.user.get 'username'

    mixpanel.track "Bookmarklet / Login", 
      name:           mediator.user.get 'username'
      id:             mediator.user.id
      email:          mediator.user.get 'email' 

  changeChannel: ->
    mixpanel.track "Bookmarklet / Switch channel", 
      name:           mediator.user.get 'username'
      id:             mediator.user.id
      email:          mediator.user.get 'email' 
      title:          mediator.channel.get('title')


  blockCreated: (params) ->
    mixpanel.track "Bookmarklet / Block created", 
      name:           mediator.user.get 'username'
      id:             mediator.user.id
      email:          mediator.user.get 'email' 
      title:          mediator.channel.get('title')
      type:           params?.type
