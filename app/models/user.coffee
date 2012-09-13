Model = require 'models/base/model'
mediator = require 'mediator'
config = require 'config'

module.exports = class User extends Model

  url: "#{config.api.versionRoot}/accounts"

  initialize: ->
    super
