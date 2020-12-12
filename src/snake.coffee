export default class Snake
	constructor: (@options)->
		{ @px, @py, @color } = @options
		@xv = 0
		@yv = 0 # Velocity
		@trail = []
		@tailSize = 5
		@frozen = false
		@dir = null

	setDir: (dir)->
		@dir = dir

	setVelocity: ->
		switch @dir
			when 'up'
				unless @yv is 1
					@xv = 0
					@yv = -1
			when 'down'
				unless @yv is -1
					@xv = 0
					@yv = 1
			when 'left'
				unless @xv is 1
					@xv = -1
					@yv = 0
			when 'right'
				unless @xv is -1
					@xv = 1
					@yv = 0
			else
				@xv = 0
				@yv = 0


	getNextPos: (boardSize)->
		@setVelocity()
		x = @px
		y = @py
		unless @frozen
			x += @xv
			y += @yv
			if x < 0 then x = boardSize - 1
			if y < 0 then y = boardSize - 1
			if x > boardSize-1 then x = 0
			if y > boardSize-1 then y = 0

		x:x
		y:y

	getColor: ->
		@color

	getTrail: ->
		@trail

	trailContains: (pos)->
		for item in @trail
			if item.x is pos.x and item.y is pos.y
				return true
		false

	setPos: (pos)->
		@px = pos.x
		@py = pos.y
		@setTrail pos

	setTrail: (pos)->
		@trail.push pos
		while @trail.length > @tailSize
			@trail.shift()

	freeze: ->
		@tailSize = 1
		@frozen = true
		setTimeout (=>
			@tailSize = 5
			@frozen = false
		), 1000

	grow: ->
		@tailSize += 1
