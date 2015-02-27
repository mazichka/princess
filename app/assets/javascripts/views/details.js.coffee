class window.Princess.Views.Details extends Backbone.View

  el: $('.yacht')

  events:
    'click .desktop .close':     'triggerEvent'
    'click .desktop .tabs [data-tab]': 'switchTab'

  triggerEvent: ->
    @$el.trigger('yacht:close')

  close: ->
    if responsive.isLargeDisplay()
      @$el.find('.yacht-inner').slideUp =>
        if @$el.next().length == 0
          @$el.prev('hr').css('opacity', 0).remove()
        @destroyFotorama()
        @$el.closest('.yacht-wrapper').remove()
    else
      if @$el.next().length == 0
        @$el.prev('hr').remove()
      @destroyFotorama()
      @$el.closest('.yacht-wrapper').remove()

  switchTab: (event) ->
    tab = $(event.currentTarget)

    unless tab.hasClass('active')
      tab.closest('.tabs').find('li').removeClass('active')
      tab.closest('.tabbable').find('.tab-pane').removeClass('active')

      tab.addClass('active')
      tab.closest('.tabbable').find(".tab-pane[data-tab=#{tab.data('tab')}]")
         .addClass('active')

    false

  initFotorama: ->
    thumbWidth = @$el.find('.photos').width() / 5
    thumbHeight = (thumbWidth / 16) * 9

    @$el.find('.fotorama').attr('data-thumb-width',  Math.floor(thumbWidth))
                          .attr('data-thumb-height', Math.floor(thumbHeight))
                          .bind 'fotorama:ready', =>
                            @calibrateDownload()

    @$el.find('.fotorama').fotorama
      width: '100%'
      maxWidth: '100%'

  recalibrateFotorama: ->
    fotorama = @$el.find('.fotorama').data('fotorama')

    if fotorama
      thumbWidth = @$el.find('.photos').width() / 5
      thumbHeight = (thumbWidth / 16) * 9

      fotorama.setOptions
        thumbWidth: thumbWidth
        thumbHeight: thumbHeight

    @calibrateDownload()

  calibrateDownload: ->
    maxTabHeight = 0

    for domElement in @$el.find('.tab-pane')
      if $(domElement).innerHeight() > maxTabHeight
        maxTabHeight = $(domElement).innerHeight()

    @$el.find('.tab-content').css('height', "#{maxTabHeight}px")

  destroyFotorama: ->
    fotorama = @$el.find('.fotorama').data('fotorama')

    fotorama.destroy() if fotorama

  switchDetails: (parameter) ->
    unless @$el.find('.mobile').hasClass(parameter)
      @$el.find('.mobile').removeClass('description')
                          .removeClass('mobile-photos')
                          .removeClass('data')
                          .removeClass('interiors')
                          .removeClass('comments')
                          .removeClass('manager')
                          .addClass(parameter)
      $('html, body').scrollTo(0, $('#toolbar').offset().top) if scroll

  render: (html, placeholder, scroll) ->
    if @$el.length > 0
      if @$el.next().length == 0
        @$el.prev('hr').css('opacity', 0).remove()
      @destroyFotorama()
      @$el.closest('.yacht-wrapper').remove()

    @$el = $(html)

    if responsive.isLargeDisplay()
      $('html, body').scrollTo(0, placeholder.offset().top + 20) if scroll
    else
      $('html, body').scrollTo(0, $('#toolbar').offset().top) if scroll

    placeholder.after(@$el)

    @calibrateDownload()
    @initFotorama()
    @delegateEvents()

    @$el.trigger('details:render')

  reattach: (placeholder, scroll) ->
    if @$el.length > 0
      @$el.detach()

      placeholder.after(@$el)

      if responsive.isLargeDisplay()
        $('html, body').scrollTo(0, placeholder.offset().top + 20) if scroll
      else
        $('html, body').scrollTo(0, $('#toolbar').offset().top) if scroll

      @recalibrateFotorama()

      @$el.trigger('details:reattach')
