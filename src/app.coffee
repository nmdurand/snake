import Board from 'board'
import Snake from 'snake'
import Apple from 'apple'

boardSize = 40 # In 'pixels'
pxSize = 20 # 'Pixels' size

export default class App
	constructor: ->
		console.log 'Initializing app.'

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

		@board.register @snake1
		@board.register @snake2
		@board.register @apple

		document.addEventListener 'keydown', (e)=> @handleKeydown e
		setInterval (=> @step()), 1000/15

	handleKeydown: (e)->
		@board.emit 'board:keydown', e.which

	step: ->
		@board.erase()
		@board.step()
		@board.drawItems()
