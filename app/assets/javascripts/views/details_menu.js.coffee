class window.Princess.Views.DetailsMenu extends Backbone.View

  el: $('#details-menu-wrapper')

  initialize: ->
    @switcher = @$el.find('#details-menu > a')
    @menu     = @$el.find('#details-menu > ul')

  events:
    'click #details-close':                       'closeDetails'
    'click #details-menu > a':                    'toggleMenu'
    'click #details-menu > ul a[data-parameter]': 'changeDetails'

  close: ->
    @menu.removeClass('opened')

  closeDetails: ->
    @$el.trigger('details-menu:close')

  show: ->
    @$el.addClass('visible')

  hide: ->
    @$el.removeClass('visible')

  toggleMenu: ->
    @menu.toggleClass('opened')

    if @menu.hasClass('opened')
      @$el.trigger('details-menu:open')

  changeDetails: (event) ->
    @close()

    @$el.trigger('details-menu:select', $(event.target).data('parameter'))

  updatePDFLink: (id) ->
    @$el.find('#details-menu a.pdf').attr('href', "/#{id}.pdf")
