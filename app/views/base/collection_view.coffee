Chaplin = require 'chaplin'
View = require 'views/base/view'

module.exports = class CollectionView extends Chaplin.CollectionView
  initialize: ->
    super
    @locals = @options.locals || {}
    
  # This class doesn’t inherit from the application-specific View class,
  # so we need to borrow the method from the View prototype:
  getTemplateFunction: View::getTemplateFunction
  getTemplateData: View::getTemplateData
  setAttributes: View::setAttributes
  hideToolTip: View::hideToolTip

  dispose: ->
    if not @disposed
      @$el.off() # Destroy all tooltips
      @locals = null
      delete @locals
      @attributes = null
      delete @attributes
    super
