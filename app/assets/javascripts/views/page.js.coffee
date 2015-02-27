class window.Princess.Views.Page extends Backbone.View

  el: $(window)

  initialize: ->
    @header  = new window.Princess.Views.Header
    @toolbar = new window.Princess.Views.Toolbar
    @list    = new window.Princess.Views.List
    @top     = new window.Princess.Views.Top

  events:
    'currency-menu:select': 'changeSearchCurrency'
    'sort-menu:select':     'sortItems'
    'view-menu:select':     'switchListColumns'
    'details-menu:select':  'switchDetails'
    'details-menu:close':   'closeDetails'
    'search:open':          'closeMenus'
    'search:start':         'search'
    'search:reset':         'resetSearch'
    'list:select':          'showDetailsMenu'
    'list:reselect':        'updatePDFLink'
    'list:unselect':        'hideDetailsMenu'
    'resize':               'redrawList'
    'yacht:close':          'closeDetails'

  showDetailsMenu: (event, id) ->
    @toolbar.showDetailsMenu()
    @toolbar.detailsMenu.updatePDFLink(id)

  updatePDFLink: (event, old_id, new_id) ->
    @toolbar.detailsMenu.updatePDFLink(new_id)

  hideDetailsMenu: ->
    @toolbar.hideDetailsMenu()

  closeMenus: ->
    @toolbar.closeMenus()

  changeSearchCurrency: (event, currency, rates) ->
    @header.search.form.changeSearchCurrency(currency)
    @list.recalculatePrice(currency, rates)

  switchListColumns: (event, columns) ->
    @list.switchColumns(columns)

  search: (event, params) ->
    @list.closeDetails()
    @list.searchItems(params)

    if params.price
      cbr.getRates (rates) =>
        @list.recalculatePrice(params.price.currency.toLowerCase(), rates)

  resetSearch: ->
    @list.resetSearch()

  sortItems: (event, parameter) ->
    @list.sortItems(parameter)

  switchDetails: (event, parameter) ->
    @list.details.switchDetails(parameter)

  closeDetails: ->
    @list.closeDetails()
    @hideDetailsMenu()

  redrawList: ->
    @list.redraw()
