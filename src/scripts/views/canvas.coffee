import Marionette from 'backbone.marionette'
import Radio from 'backbone.radio'
import template from 'templates/canvas'

export default class CanvasView extends Marionette.View
	template: template
	className: 'canvas'

	ui:
		canvas: '#canvas'

	initialize: ->
		console.log 'Initializing CanvasView', @options
		@canvasChannel = Radio.channel 'canvas'
		@gameChannel = Radio.channel 'game'

		@boardSize = @gameChannel.request 'board:size'
		@pixelSize = @gameChannel.request 'pixel:size'

		@canvasChannel.reply 'erase:canvas', => @erase()
		@canvasChannel.reply 'draw:canvas', (posArray,color)=> @draw posArray,color

	onRender: ->
		@ui.canvas.attr
			width: @boardSize*@pixelSize
			height: @boardSize*@pixelSize
		@ctx = @ui.canvas.get(0).getContext '2d'

	erase: =>
		@ctx.fillStyle = 'black'
		@ctx.fillRect 0, 0, @boardSize*@pixelSize, @boardSize*@pixelSize

	draw: (posArray,color)=>
		for pos in posArray
			@ctx.fillStyle = color
			@ctx.fillRect pos.x*@pixelSize, pos.y*@pixelSize, @pixelSize-2, @pixelSize-2
