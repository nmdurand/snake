
export default class Board
	constructor: (options)->
		{ @ctx, @boardSize, @pixelSize } = options

	getSize: ->
		@boardSize

	erase: ->
		@ctx.fillStyle = 'black'
		@ctx.fillRect 0, 0, @boardSize*@pixelSize, @boardSize*@pixelSize

	draw: (pos,color)->
		@ctx.fillStyle = color
		@ctx.fillRect pos.x*@pixelSize, pos.y*@pixelSize, @pixelSize-2, @pixelSize-2
