Model = require 'models/base/model'
mediator = require 'mediator'
config = require 'config'

module.exports = class User extends Model

  url: "#{config.api.versionRoot}/accounts"

  validateSession: (cb)->
    if !mediator.storage.has('accessToken') then return cb(false)

    url = config.api.versionRoot + '/tokens/validate'
    $.ajax url,
      data: 
        token: mediator.storage.get 'accessToken'
      type: "POST"
      complete: (xhr, data)=>
        isValid = xhr.status isnt 404
        cb(isValid)