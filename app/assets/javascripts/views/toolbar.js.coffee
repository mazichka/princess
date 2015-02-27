class window.Princess.Views.Toolbar extends Backbone.View

  el: $('#toolbar')

  initialize: ->
    @viewMenu     = new window.Princess.Views.ViewMenu
    @sortMenu     = new window.Princess.Views.SortMenu
    @currencyMenu = new window.Princess.Views.CurrencyMenu
    @detailsMenu  = new window.Princess.Views.DetailsMenu

  events:
    'sort-menu:open':     'shownSortMenu'
    'currency-menu:open': 'shownCurrencyMenu'

  shownSortMenu: ->
    @currencyMenu.close()

  shownCurrencyMenu: ->
    @sortMenu.close()

  closeMenus: ->
    @sortMenu.close()
    @currencyMenu.close()
    @detailsMenu.close()

  showDetailsMenu: ->
    @$el.find('#filter').removeClass('visible')
    @detailsMenu.show()

  hideDetailsMenu: ->
    @$el.find('#filter').addClass('visible')
    @detailsMenu.hide()
