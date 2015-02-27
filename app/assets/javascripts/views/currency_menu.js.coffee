class window.Princess.Views.CurrencyMenu extends Backbone.View

  el: $('#currency-menu')

  initialize: ->
    @switcher = @$el.find('> a')
    @menu     = @$el.find('> ul')

  events:
    'click > a':    'toggleMenu'
    'click > ul a': 'changeCurrency'

  toggleMenu: ->
    @menu.toggleClass('opened')

    if @menu.hasClass('opened')
      @$el.trigger('currency-menu:open')

  close: ->
    @menu.removeClass('opened')

  changeCurrency: (event) ->
    @close()

    currency = $(event.target).data('currency')

    cbr.getRates (rates) =>
      @$el.trigger('currency-menu:select', [currency, rates])
