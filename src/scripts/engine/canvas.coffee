import Marionette from 'backbone.marionette'
import Radio from 'backbone.radio'

export default class CanvasController extends Marionette.MnObject
	initialize: (options)->
		console.log 'Initializing canvas controller'
		@canvasChannel = Radio.channel 'canvas'

	erase: ->
		@canvasChannel.request 'erase:canvas'

	draw: (posArray,color)->
		@canvasChannel.request 'draw:canvas', posArray, color
