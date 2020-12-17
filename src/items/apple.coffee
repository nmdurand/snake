import BoardItem from 'boardItem'

export default class Snake extends BoardItem
	constructor: (options)->
		super()
		{ @board, @color, @id } = options

		@setNewPos()

	getType: ->
		'apple'

	getId: ->
		@id

	draw: ->
		@board.draw @pos, 'orange'

	hasPosition: (pos)->
		if pos?
			if @pos.x is pos.x and @pos.y is pos.y
				return true
		false

	setNewPos: ->
		@pos =
			x: Math.floor Math.random()*@board.getSize()
			y: Math.floor Math.random()*@board.getSize()

	getPoints: ->
		10
