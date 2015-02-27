class window.Princess.Views.SortMenu extends Backbone.View

  el: $('#sort-menu')

  initialize: ->
    @switcher = @$el.find('> a')
    @menu     = @$el.find('> ul')

  events:
    'click > a':    'toggleMenu'
    'click > ul a': 'changeSort'

  toggleMenu: ->
    @menu.toggleClass('opened')

    if @menu.hasClass('opened')
      @$el.trigger('sort-menu:open')

  close: ->
    @menu.removeClass('opened')

  changeSort: (event) ->
    @close()

    @$el.trigger('sort-menu:select', $(event.target).data('parameter'))
