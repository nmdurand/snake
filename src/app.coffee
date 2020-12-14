import Board from 'board'
import Snake from 'snake'
import Apple from 'apple'

boardSize = 40 # In 'pixels'
pxSize = 20 # 'Pixels' size

export default class App
	constructor: ->
		console.log 'Initializing app.'
		@items = []

	start: ->
		console.log 'Startinging app.'
		canvas = document.getElementById 'canvas'
		canvas.setAttribute 'width', boardSize*pxSize
		canvas.setAttribute 'height', boardSize*pxSize
		ctx = canvas.getContext '2d'

		@board = new Board
			ctx: ctx
			boardSize: boardSize
			pixelSize: pxSize

		@snake1 = new Snake
			board: @board
			color: 'purple'
			keys:
				left: 37
				up: 38
				right: 39
				down: 40

		@snake2 = new Snake
			board: @board
			color: 'blue'
			keys:
				left: 81
				up: 90
				right: 68
				down: 83

		@apple = new Apple
			color: 'orange'
			board: @board

		@registerItem @snake1
		@registerItem @snake2
		@registerItem @apple

		document.addEventListener 'keydown', (e)=> @handleKeydown e
		setInterval (=> @refreshGame()), 1000/15

	handleKeydown: (e)->
		for item in @items
			item.emit 'keydown', e.which

	refreshGame: ->
		@board.erase()
		@step()
		@drawItems()

	registerItem: (item)->
		@items.push item

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

	drawItems: ->
		for item in @items
			item.draw()
