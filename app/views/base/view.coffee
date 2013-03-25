require 'lib/view_helper'
Chaplin = require 'chaplin'


module.exports = class View extends Chaplin.View
  
  getTemplateFunction: ->
    @template