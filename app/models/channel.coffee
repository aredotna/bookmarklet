Model = require 'models/base/model'

module.exports = class Channel extends Model  
  urlRoot: -> "#{config.api.versionRoot}/channels"