window.responsive = ( ->

  $ = window.jQuery

  isXLargeDesktop = ->
    $(document).width() >= 1440

  isLargeDesktop = ->
    $(document).width() >= 1200 and $(document).width() <= 1439

  isDesktop = ->
    $(document).width() >= 980 and $(document).width() <= 1199

  isLandscape = ->
    $(document).width() >= 768 and $(document).width() <= 979

  isPortrait = ->
    $(document).width() >= 481 and $(document).width() <= 767

  isPhone = ->
    $(document).width() <= 480

  isLargeDisplay = ->
    isXLargeDesktop() or isLargeDesktop() or isDesktop() or isLandscape()

  isSmallDisplay = ->
    isPortrait() or isPhone()

  isXLargeDesktop: isXLargeDesktop
  isLargeDesktop: isLargeDesktop
  isDesktop: isDesktop
  isLandscape: isLandscape
  isPortrait: isPortrait
  isPhone: isPhone
  isLargeDisplay: isLargeDisplay
  isSmallDisplay: isSmallDisplay

)()
