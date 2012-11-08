Model = require 'models/base/model'
mediator = require 'mediator'

module.exports = class Metrics extends Model

  initialize: ->
    super

    @subscribeEvent 'login', @login

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

    mixpanel.track "Login", 
      name:           mediator.user.get 'username'
      id:             mediator.user.id
      email:          mediator.user.get 'email' 