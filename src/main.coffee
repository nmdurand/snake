import Board from 'board'
import Snake from 'snake'
import Apple from 'apple'

boardSize = 40 # In 'pixels'
pxSize = 20 # 'Pixels' size

ctx = null # Canvas context

board = null
snake1 = null
snake2 = null
apple = null

window.onload = ->
	canvas = document.getElementById 'canvas'
	canvas.setAttribute 'width', boardSize*pxSize
	canvas.setAttribute 'height', boardSize*pxSize
	ctx = canvas.getContext '2d'

	board = new Board
		ctx: ctx
		boardSize: boardSize
		pixelSize: pxSize

	snake1 = new Snake
		color: 'purple'
		board: board

	snake2 = new Snake
		color: 'blue'
		board: board

	apple = new Apple
		color: 'orange'
		board: board

	board.register snake1
	board.register snake2
	board.register apple

	document.addEventListener 'keydown', handleKeydown
	setInterval step, 1000/15

handleKeydown = (e)->
	switch e.which
		when 37
			snake1.setDir 'left'
		when 38
			snake1.setDir 'up'
		when 39
			snake1.setDir 'right'
		when 40
			snake1.setDir 'down'
		when 81
			snake2.setDir 'left'
		when 90
			snake2.setDir 'up'
		when 68
			snake2.setDir 'right'
		when 83
			snake2.setDir 'down'

step = ->
	board.erase()
	board.step()
	board.drawItems()
