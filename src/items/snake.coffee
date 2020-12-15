import BoardItem from 'boardItem'

DIRECTIONS = ['up','down','left','right']

export default class Snake extends BoardItem
	constructor: (options)->
		super()
		{ @playerId, @board, @color, @keys } = options
		@pos =
			x: Math.floor Math.random()*@board.getSize()
			y: Math.floor Math.random()*@board.getSize()
		@vel =
			x: 0
			y: 0
		@trail = []
		@tailSize = 3
		@frozen = false
		@dir = null
		@score = 0

		if @keys?
			@on 'keydown', (kc)=> @handleKeydown kc
		else
			@triggerNewDirection()

	getType: ->
		'snake'

	draw: ->
		for pos in @trail
			@board.draw pos, @color

	hasPosition: (pos)->
		for item in @trail
			if item.x is pos.x and item.y is pos.y
				return true
		false

	handleKeydown: (keycode)->
		switch keycode
			when @keys.left
				@setDir 'left'
			when @keys.up
				@setDir 'up'
			when @keys.right
				@setDir 'right'
			when @keys.down
				@setDir 'down'

	triggerNewDirection: ->
		timeout = 1500*Math.random()
		setTimeout =>
			@setDir DIRECTIONS[Math.floor(Math.random()*4)]
			@triggerNewDirection()
		, timeout

	setDir: (dir)->
		@dir = dir

	setVelocity: ->
		switch @dir
			when 'up'
				unless @vel.y is 1
					@vel =
						x: 0
						y: -1
			when 'down'
				unless @vel.y is -1
					@vel =
						x: 0
						y: 1
			when 'left'
				unless @vel.x is 1
					@vel =
						x: -1
						y: 0
			when 'right'
				unless @vel.x is -1
					@vel =
						x: 1
						y: 0
			else
				@vel =
					x: 0
					y: 0

	getNextPos: ->
		@setVelocity()
		{x, y} = @pos
		unless @frozen
			x += @vel.x
			y += @vel.y
			if x < 0 then x = @board.getSize() - 1
			if y < 0 then y = @board.getSize() - 1
			if x > @board.getSize()-1 then x = 0
			if y > @board.getSize()-1 then y = 0

		x:x
		y:y

	getColor: ->
		@color

	getTrail: ->
		@trail

	setPos: (pos)->
		@pos = pos if pos?
		@setTrail pos

	setTrail: (pos)->
		@trail.push pos if pos?
		while @trail.length > @tailSize
			@trail.shift()

	freeze: ->
		@tailSize = 3
		@frozen = true
		setTimeout (=>
			@tailSize = 3
			@frozen = false
		), 1000

	grow: ->
		@tailSize += 1

	updatePoints: (val)->
		if @playerId
			@score += val
			@updateScoreDisplay()

	updateScoreDisplay: ->
		scoreDiv = document.getElementById "player#{@playerId}-score"
		scoreDiv.innerHTML = @score
