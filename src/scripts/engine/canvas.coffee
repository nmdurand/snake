import Marionette from 'backbone.marionette'
import Radio from 'backbone.radio'

export default class CanvasController extends Marionette.MnObject
	initialize: (options)->
		console.log 'Initializing canvas controller'
		@boardChannel = Radio.channel 'board'

	erase: ->
		@boardChannel.request 'erase:canvas'

	draw: (posArray,color)->
		@boardChannel.request 'draw:canvas', posArray, color
