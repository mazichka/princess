class window.Princess.Views.List extends Backbone.View

  el: $('#content-inner')

  initialize: ->
    @details = new window.Princess.Views.Details

  events:
    'click .yacht-preview': 'selectItem'
    'details:render':       'openDetails'

  redraw: ->
    @$el.find('hr').remove()

    domElements = @$el.find('.yacht-preview.visible')

    if @$el.hasClass('two-column')
      columns = 2
    else
      columns = 3

    for domElement, index in domElements
      if (index + 1) < domElements.length
        if (index + 1) % columns == 0
          $(domElement).after('<hr></hr>')

    if @$el.find('.yacht-preview.selected').length > 0
      id = @$el.find('.yacht-preview.selected').data('yacht-id')

      @details.reattach(@placeholder(id), false)

  toggleOpacity: (show) ->
    if show
      @$el.find('.yacht-preview, .yacht').css('opacity', 1)
      @$el.css('height', 'auto')
    else
      @$el.css('height', @$el.height())
      @$el.find('.yacht-preview, .yacht').css('opacity', 0)

  placeholder: (id) ->
    if responsive.isLargeDisplay()
      position = 0
      previews = @$el.find('.yacht-preview.visible')
      len = previews.length

      for i in [1..len]
        if $(previews[i - 1]).data('yacht-id').toString() == id.toString()
          position = i
          break

      if @$el.hasClass('two-column')
        if len % 2 == 0
          if position >= len - 1
            hr = $('<hr></hr>')
            if position % 2 == 0
              $(previews[position - 1]).after(hr)
            else
              $(previews[position]).after(hr)
            return hr
          else
            if position % 2 == 0
              return $(previews[position - 1]).next('hr')
            else
              return $(previews[position]).next('hr')
        else
          if position == len
            hr = $('<hr></hr>')
            $(previews[position - 1]).after(hr)
            return hr
          else
            if position % 2 == 0
              return $(previews[position - 1]).next('hr')
            else
              return $(previews[position]).next('hr')
      else
        switch len % 3
          when 0
            console.log(0)
            if position >= len - 2
              hr = $('<hr></hr>')
              $(previews[position + (len - position) - 1]).after(hr)
              return hr
            else
              switch position % 3
                when 0 then return $(previews[position - 1]).next('hr')
                when 1 then return $(previews[position + 1]).next('hr')
                when 2 then return $(previews[position]).next('hr')
          when 1
            if position == len
              hr = $('<hr></hr>')
              $(previews[position - 1]).after(hr)
              return hr
            else
              switch position % 3
                when 0 then return $(previews[position - 1]).next('hr')
                when 1 then return $(previews[position + 1]).next('hr')
                when 2 then return $(previews[position]).next('hr')
          when 2
            console.log(2)
            if position >= len - 1
              hr = $('<hr></hr>')
              $(previews[position + (len - position) - 1]).after(hr)
              return hr
            else
              switch position % 3
                when 0 then return $(previews[position - 1]).next('hr')
                when 1 then return $(previews[position + 1]).next('hr')
                when 2 then return $(previews[position]).next('hr')

    else
      @$el.find(".yacht-preview[data-yacht-id=#{id}]")

  openDetails: ->
    @$el.addClass('details')

  closeDetails: ->
    @details.close()
    @$el.find('.yacht-preview.selected').removeClass('selected')
    @$el.removeClass('details')

  selectItem: (event) ->
    currentYachtPreview = $(event.currentTarget)
    yachtID              = parseInt(currentYachtPreview.data('yacht-id'))

    if currentYachtPreview.hasClass('selected')
      currentYachtPreview.removeClass('selected')
      @closeDetails()
      @$el.trigger('list:unselect')
    else
      $.ajax
        url: '/' + yachtID
        success: (response) =>
          if @$el.find('.yacht-preview.selected').length > 0
            oldYachtID = @$el.find('.yacht-preview.selected').data('yacht-id')

            @$el.find('.yacht-preview.selected').removeClass('selected')
            currentYachtPreview.addClass('selected')

            @$el.trigger('list:reselect', [oldYachtID, yachtID])
          else
            currentYachtPreview.addClass('selected')

            @$el.trigger('list:select', yachtID)

          @details.render(response, @placeholder(yachtID), true)

  switchColumns: (columns) ->
    if columns == 'two'
      @$el.removeClass('three-column').addClass('two-column')
    else
      @$el.removeClass('two-column').addClass('three-column')

    @toggleOpacity(false)

    @$el.find('hr').remove()

    @redraw()

    @toggleOpacity(true)

  recalculatePrice: (currency, rates) ->
    for domElement, index in @$el.find('.yacht-preview .price')
      element          = $(domElement)
      priceElement    = element.find('[data-price]')
      currencyElement = element.find('[data-currency]')

      unless currencyElement.data('currency') == currency
        newPrice = cbr.convert(parseFloat(priceElement.data('price')),
                               rates[currencyElement.data('currency').toUpperCase()],
                               rates[currency.toUpperCase()])

        priceElement.data('price', newPrice).html(accounting.formatNumber(newPrice, 0, ' '))
        currencyElement.data('currency', currency)

        switch currency
          when 'usd' then currencyElement.html('$')
          when 'eur' then currencyElement.html('&euro;')
          when 'gbp' then currencyElement.html('&pound;')

  searchItems: (params) ->
    @$el.find('.yacht-preview').removeClass('selected')

    search = (rates) =>
      pattern = (indexData) =>

        if params.name
          buffer = indexData.name.toLowerCase()

          if buffer.search(params.name.toLowerCase()) == -1
            return false

        if params.price
          searchPrice = Math.round(params.price.value)
          indexPrice  = parseFloat(indexData.price)
          unless indexData.currency == params.price.currency
            indexPrice = cbr.convert(indexPrice,
                                     rates[indexData.currency.toUpperCase()],
                                     rates[params.price.currency.toUpperCase()])
          indexPrice = Math.round(indexPrice)

          console.log(searchPrice)
          console.log(indexPrice)

          switch params.price.sign
            when '<' then return indexPrice < searchPrice
            when '=' then return indexPrice == searchPrice
            when '>' then return indexPrice > searchPrice

        true

      @toggleOpacity(false)

      @$el.find('hr').remove()

      for domElement, index in @$el.find('.yacht-preview')
        element   = $(domElement)
        indexData = JSON.parse(element.attr('data-index'))

        if pattern(indexData)
          element.addClass('visible')
        else
          element.removeClass('visible')

      @redraw()

      @toggleOpacity(true)

    if params.price
      cbr.getRates(search)
    else
      search()

  resetSearch: ->
    @toggleOpacity(false)

    @$el.find('.yacht-preview').addClass('visible')
    @$el.find('hr').remove()

    @redraw()

    @toggleOpacity(true)

  sortItems: (parameter) ->

    sort = (rates) =>
      listMap = []

      @toggleOpacity()

      @$el.find('hr').remove()

      for domElement, index in @$el.find('.yacht-preview')
        element = $(domElement)
        indexData = JSON.parse(element.attr('data-index'))
        result = { id: element.data('yacht-id') }

        switch parameter
          when 'year' then result.value = parseInt(indexData.year)
          when 'length' then result.value = parseFloat(indexData.length)
          when 'price'
            if indexData.currency == 'EUR'
              result.value = parseFloat(indexData.price)
            else
              result.value = cbr.convert(parseFloat(indexData.price),
                                         rates[indexData.currency.toUpperCase()],
                                         rates.EUR)

        listMap.push(result)

      listMap.sort (a, b) ->
        return 0 if a.value == b.value

        if a.value > b.value
          return 1
        else
          return -1

      for m, i in listMap
        element = @$el.find(".yacht-preview[data-yacht-id=#{m.id}]")

        @$el.prepend(element.detach())

      @redraw()

      $(document).trigger('yacht:reattach')

      @toggleOpacity(true)

    if parameter == 'price'
      cbr.getRates(sort)
    else
      sort()
