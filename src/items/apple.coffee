import BoardItem from 'boardItem'

export default class Snake extends BoardItem
	constructor: (options)->
		super()
		{ @board, @color } = options

		@setNewPos()

	getType: ->
		'apple'

	draw: ->
		@board.draw @pos, 'orange'


	hasPosition: (pos)->
		if @pos.x is pos.x and @pos.y is pos.y
			true
		else
			false

	setNewPos: ->
		@pos =
			x: Math.floor Math.random()*@board.getSize()
			y: Math.floor Math.random()*@board.getSize()