import Snake from 'snake'

boardSize = 40
pxSize = 20 # 'Pixels' size

ctx = null # Canvas context
apple =
	x: 10
	y: 10

snake1 = new Snake
	px: 7
	py: 7
	color: 'purple'

snake2 = new Snake
	px: 4
	py: 4
	color: 'blue'

window.onload = ->
	canvas = document.getElementById 'canvas'
	canvas.setAttribute 'width', boardSize*pxSize
	canvas.setAttribute 'height', boardSize*pxSize
	ctx = canvas.getContext '2d'

	document.addEventListener 'keydown', handleKeydown
	setInterval processNewFrame, 1000/15

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

eraseBoard = ->
	ctx.fillStyle = 'black'
	ctx.fillRect 0, 0, boardSize*pxSize, boardSize*pxSize

drawSnake = (snake)->
	ctx.fillStyle = snake.getColor()
	for pos in snake.getTrail()
		ctx.fillRect pos.x*pxSize, pos.y*pxSize, pxSize-2, pxSize-2

drawApple = ->
	ctx.fillStyle= 'orange'
	ctx.fillRect apple.x*pxSize, apple.y*pxSize, pxSize-2, pxSize-2

setNewApple = ->
	apple =
		x: Math.floor Math.random()*boardSize
		y: Math.floor Math.random()*boardSize

processNewFrame = ->
	eraseBoard()

	step snake1, snake2.getTrail()
	step snake2, snake1.getTrail()

	drawApple()

step = (snake,avoidPositions)->
	nextPos = snake.getNextPos boardSize
	if positionListContains avoidPositions, nextPos
		snake.freeze()
	else
		if nextPos.x is apple.x and nextPos.y is apple.y
			snake.grow()
			setNewApple()
		snake.setPos nextPos
	drawSnake snake

positionListContains = (posList,pos)->
	for item in posList
		if item.x is pos.x and item.y is pos.y
			return true
	false
