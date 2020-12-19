
export default class CanvasController
	constructor: (options)->
		{ @controller } = options
		@boardSize = @controller.getBoardSize()
		@pixelSize = @controller.getPixelSize()
		@ctx = @controller.getCtx()

	erase: ->
		@ctx.fillStyle = 'black'
		@ctx.fillRect 0, 0, @boardSize*@pixelSize, @boardSize*@pixelSize

	draw: (posArray,color)->
		for pos in posArray
			@ctx.fillStyle = color
			@ctx.fillRect pos.x*@pixelSize, pos.y*@pixelSize, @pixelSize-2, @pixelSize-2
