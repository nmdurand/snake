import Marionette from 'backbone.marionette'
import template from 'templates/board'

export default class BoardView extends Marionette.View
	template: template
	className: 'board'

	ui:
		canvas: '#canvas'

	initialize: ->
		console.log 'Initializing BoardView', @options
		{ @controller } = @options
		@boardSize = @controller.getBoardSize()
		@pixelSize = @controller.getPixelSize()

	onRender: ->
		canvas = document.getElementById 'canvas'
		@ui.canvas.attr
			'width': @boardSize*@pixelSize
			'height': @boardSize*@pixelSize
		@ctx = @ui.canvas.get(0).getContext '2d'

		@controller.getCtx = =>
			@ctx
	# getSize: ->
	# 	@boardSize
	#
	# erase: ->
	# 	@ctx.fillStyle = 'black'
	# 	@ctx.fillRect 0, 0, @boardSize*@pixelSize, @boardSize*@pixelSize
	#
	# draw: (pos,color)->
	# 	@ctx.fillStyle = color
	# 	@ctx.fillRect pos.x*@pixelSize, pos.y*@pixelSize, @pixelSize-2, @pixelSize-2
