Collection = require 'models/base/collection'
Channel = require 'models/channel'
config = require 'config'
mediator = require 'mediator'


module.exports = class ChannelCollection extends Collection

  model: Channel