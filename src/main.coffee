
boardSize = 15
pxSize = 20 # 'Pixels' size

px = py = 7 # Head position
xv = yv = 0 # Velocity
ax = ay = 10 # Aim position
ctx = null # Canvas context
trail = []
tailSize = 5

window.onload = ->
	canvas = document.getElementById 'canvas'
	canvas.setAttribute 'width', boardSize*pxSize
	canvas.setAttribute 'height', boardSize*pxSize
	ctx = canvas.getContext '2d'

	document.addEventListener 'keydown', handleKeydown
	setInterval tick, 1000/15

handleKeydown = (e)->
	switch e.which
		when 37
			unless xv is 1
				xv = -1
				yv = 0
		when 38
			unless yv is 1
				xv = 0
				yv = -1
		when 39
			unless xv is -1
				xv = 1
				yv = 0
		when 40
			unless yv is -1
				xv = 0
				yv = 1

tick = ->
	ctx.fillStyle = 'black'
	ctx.fillRect 0, 0, boardSize*pxSize, boardSize*pxSize

	px += xv
	py += yv
	if px < 0 then px = boardSize - 1
	if py < 0 then py = boardSize - 1
	if px > boardSize-1 then px = 0
	if py > boardSize-1 then py = 0

	ctx.fillStyle = 'lightgreen'
	for item in trail
		ctx.fillRect item.x*pxSize, item.y*pxSize, pxSize-2, pxSize-2
		if item.x is px and item.y is py
			tailSize = 5

	trail.push
		x: px
		y: py
	while trail.length > tailSize
		trail.shift()

	if ax is px and ay is py
		tailSize += 1

		ax= Math.floor Math.random()*boardSize
		ay= Math.floor Math.random()*boardSize

	ctx.fillStyle= 'indianred'
	ctx.fillRect ax*pxSize, ay*pxSize, pxSize-2, pxSize-2
