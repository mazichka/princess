window.cbr = ( ->

  $       = window.jQuery
  storage = window.localStorage

  unless storage
    storage =
      storage: {}
      getItem: (key) ->
        @storage[key]
      setItem: (key, value) ->
        @storage[key] = value

  cache = (value) ->
    d = new Date()
    key = "rates_#{d.getDate()}_#{d.getMonth()}_#{d.getYear()}"

    if value?
      storage.setItem key, JSON.stringify(value)
    else
      JSON.parse(storage.getItem key)

  getRates = (callback) ->
    rates = cache()
    if rates
      callback.call null, rates
    else
      $.ajax
        url: "/rates/"
        dateType: "json"
        success: (response) ->
          cache response
          callback.call null, response

  convert = (value, from, to) ->
    fromPrice = from.value / from.nominal
    toPrice   = to.value   / to.nominal

    (fromPrice * value) / toPrice

  getRates: getRates
  convert: convert

)()
