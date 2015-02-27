class window.Princess.Views.Top extends Backbone.View

  el: $('#top')

  events:
    'click a': 'scrollToTop'

  scrollToTop: ->
    $('html,body').scrollTo(0, 0)
