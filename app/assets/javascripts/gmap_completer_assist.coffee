$(document).ready ->
	class FandyGmapsCompleter extends GmapsCompleter
	  constructor: (opts) ->
	    super(opts)
	    lat = opts.pos[0]
	    lng = opts.pos[1]
	    
	    
	class GmapCompleterAssist extends GmapsCompleterDefaultAssist
	  positionOutputter: (latLng) ->
	    $('.form-control.gmaps-input-latitude').val(latLng.lat)
	    $('.form-control.gmaps-input-longitude').val(latLng.lng)

	window.FandyGmapsCompleter = FandyGmapsCompleter
	window.GmapCompleterAssist = GmapCompleterAssist
  