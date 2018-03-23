# # Place all the behaviors and hooks related to the matching controller here.
# # All this logic will automatically be available in application.js.
# # You can use CoffeeScript in this file: http://coffeescript.org/

# $(document).ready ->
# 	formGmapsCompleter = (lat, lng, _mapElem) ->
# 	  completer = new FandyGmapsCompleter(
# 	    inputField: 'input_autocomplete',
# 	    errorField: '#gmaps-error',
# 	    mapElem: _mapElem,
# 	    pos: [lat, lng],
# 	    zoomLevel: 2,
# 	    debugOn: false,
# 	    assist: GmapCompleterAssist
# 	  )
# 	  # completer.autoCompleteInit 
# 	  #   country: 'us'

# 	showGmapsCompleter = (lat, lng, _mapElem) ->
# 	  new FandyGmapsCompleter(
# 	    inputField: '',
# 	    errorField: '',
# 	    mapElem: _mapElem,
# 	    pos: [lat, lng],
# 	    zoomLevel: 8,
# 	    debugOn: false,
# 	    assist: GmapCompleterAssist
#   )

# 	window.showGmapsCompleter = showGmapsCompleter  
# 	window.formGmapsCompleter = formGmapsCompleter  
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  formGmapsCompleter = (lat, lng, _mapElem) ->
    completer = new FandyGmapsCompleter(
      inputField: '.form-control.gmaps-input-address',
      errorField: '#gmaps-error',
      mapElem: _mapElem,
      pos: [lat, lng],
      zoomLevel: 2,
      debugOn: false,
      assist: GmapCompleterAssist
    )
    completer.autoCompleteInit 
      country: 'us'

  showGmapsCompleter = (lat, lng, _mapElem) ->
    new FandyGmapsCompleter(
      inputField: '',
      errorField: '',
      mapElem: _mapElem,
      pos: [lat, lng],
      zoomLevel: 8,
      debugOn: false,
      assist: GmapCompleterAssist
    )

  window.showGmapsCompleter = showGmapsCompleter  
  window.formGmapsCompleter = formGmapsCompleter  