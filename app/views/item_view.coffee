View = require 'views/base/view'
template = require 'templates/item'
mediator = require 'mediator'

module.exports = class ItemView extends View
  template: template
  className: 'template-upload'

  initialize: (options) ->
    @modelBind 'change:url', @render

  runProgressBar: ->
    that = @
    @progress = setInterval(()=>
      $bar = that.$('.bar');

      if $bar.width() is 400
        clearInterval(progress)
        $('.progress').removeClass('active')
      else
        $bar.width($bar.width()+200)
    , 100)

  render: =>
    @$el.html @template(@model.toJSON())
    clearInterval(@progress)
    return this