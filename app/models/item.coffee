Model = require 'models/base/model'
mediator = require 'mediator'

module.exports = class Item extends Model

  defaults:
    percent: 0

  setURL: ->
    channelslug = mediator.channel.get('slug')
    @set
      url:"http://are.na/#/#{channelslug}/show:#{@id}"
      percent: 100