class window.Princess.Views.ViewMenu extends Backbone.View

  el: $('#view-menu')

  events:
    'click a': 'toggleView'

  toggleView: (event) ->
    currentView = $(event.currentTarget)

    unless currentView.hasClass('opened')
      @$el.find('a').removeClass('selected')
      currentView.addClass('selected')

      @$el.trigger('view-menu:select', currentView.data('view'))
