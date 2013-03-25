Model = require 'models/base/model'
config = require 'config'

module.exports = class Channel extends Model  
  urlRoot: -> "#{config.api.versionRoot}/channels"