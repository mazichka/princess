class window.Princess.Views.Search extends Backbone.View

  el: $('#search')

  initialize: ->
    @form = new window.Princess.Views.SearchForm

  events:
    'search-form:search': 'formSubmitted'
    'search-form:reset':  'formReseted'

  show: ->
    @$el.addClass('opened').trigger('search:open')

  hide: ->
    @$el.removeClass('opened')

  toggle: ->
    if @$el.hasClass('opened')
      @hide()
    else
      @show()

  formSubmitted: (event, params) ->
    @hide()
    @$el.trigger('search:start', params)

  formReseted: ->
    @hide()

    @$el.trigger('search:reset')
