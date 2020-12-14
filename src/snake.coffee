import EventEmitter from 'events'

export default class Snake extends EventEmitter
	constructor: (options)->
		super()
		{ @board, @color } = options
		@pos =
			x: Math.floor Math.random()*@board.getSize()
			y: Math.floor Math.random()*@board.getSize()
		@xv = 0
		@yv = 0 # Velocity
		@trail = []
		@tailSize = 5
		@frozen = false
		@dir = null

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

	getNextPos: ->
		@setVelocity()
		{x, y} = @pos
		unless @frozen
			x += @xv
			y += @yv
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
		@pos = pos
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
		console.log 'GROWING'
		@tailSize += 1
