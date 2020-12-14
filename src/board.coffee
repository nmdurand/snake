import EventEmitter from 'events'

export default class Board extends EventEmitter
	constructor: (options)->
		super()
		{ @ctx, @boardSize, @pixelSize } = options
		@items = []

	getSize: ->
		@boardSize

	erase: ->
		@ctx.fillStyle = 'black'
		@ctx.fillRect 0, 0, @boardSize*@pixelSize, @boardSize*@pixelSize

	draw: (pos,color)->
		@ctx.fillStyle = color
		@ctx.fillRect pos.x*@pixelSize, pos.y*@pixelSize, @pixelSize-2, @pixelSize-2

	register: (item)->
		@items.push item

	drawItems: ->
		for item in @items
			item.draw()

	step: ->
		for item1 in @items
			if item1.getType() is 'snake'
				nextPos1 = item1.getNextPos()
				for item2 in @items
					if item2.getType() is 'apple'
						if item2.hasPosition nextPos1
							item1.grow()
							item2.setNewPos()
					else if item2.getType() is 'snake'
						if item2.hasPosition nextPos1
							item1.freeze()
							break
				item1.setPos nextPos1
