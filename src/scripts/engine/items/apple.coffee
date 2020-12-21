import Radio from 'backbone.radio'
import BoardItem from 'engine/items/item'

export default class Apple extends BoardItem
	constructor: (options)->
		super()
		{ @color } = options

		@gameChannel = Radio.channel 'game'
		@canvasChannel = Radio.channel 'canvas'

		@boardSize = @gameChannel.request 'board:size'
		@setNewPos()

	getType: ->
		'apple'

	getPosition: ->
		[@pos]

	getColor: ->
		@color

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
