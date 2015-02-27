class window.Princess.Views.Header extends Backbone.View

  el: $('#header')

  initialize: ->
    @switcher = @$el.find('#search-switcher')
    @search   = new window.Princess.Views.Search

  events:
    'click #search-switcher': 'toggleSearch'

  toggleSearch: ->
    @search.toggle()
