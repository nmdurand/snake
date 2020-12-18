import BoardItem from 'engine/boardItem'

export default class Snake extends BoardItem
	constructor: (options)->
		super()
		{ @color, @controller } = options
		@boardSize = @controller.getBoardSize()

		@setNewPos()

	getType: ->
		'apple'

	draw: ->
		@controller.draw @pos, 'orange'

	hasPosition: (pos)->
		if pos?
			if @pos.x is pos.x and @pos.y is pos.y
				return true
		false

	setNewPos: ->
		@pos =
			x: Math.floor Math.random()*@boardSize
			y: Math.floor Math.random()*@boardSize

	getPoints: ->
		10
