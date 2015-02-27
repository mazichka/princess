class window.Princess.Views.SearchForm extends Backbone.View

  el: $('#search-form')

  events:
    'submit':                'search'
    'reset':                 'reset'
    'keypress [name=price]': 'filterPrice'

  initialize: ->
    @name     = @$el.find('[name=name]')
    @sign     = @$el.find('[name=sign]')
    @price    = @$el.find('[name=price]')
    @currency = @$el.find('[name=currency]')

  changeSearchCurrency: (currency) ->
    @currency.val(currency.toUpperCase())

  reset: ->
    @$el.trigger('search-form:reset')

  filterPrice: (event) ->
    charCode = if event.which
                 event.which
               else
                 event.keyCode

    if charCode > 31 and (charCode < 48 or charCode > 57)
      return false

  search: (event) ->
    params = {}

    if @name.val().length > 0
      params.name = @name.val()

    if @price.val().length > 0
      params.price =
        sign:     @sign.val()
        value:    Math.floor(parseFloat(@price.val()))
        currency: @currency.val()

    if params.name or params.price
      @$el.trigger('search-form:search', params)
    else
      @$el.trigger('search-form:reset')

    false
