import Radio from 'backbone.radio'
import BoardItem from 'engine/boardItem'

DIRECTIONS = ['up','down','left','right']
FAIL_TIMEOUT = 1000

export default class Snake extends BoardItem
	constructor: (options)->
		super()
		{ @id, @playerName, @color, @keys, @boardSize } = options
		console.log 'Initializing snake', options
		@lives = 3
		@frozen = false
		@score = 0
		@tailSize = 5
		@scoresChannel = Radio.channel 'scores'
		@playerStateChannel = Radio.channel "state:#{@id}"

		@gameChannel = Radio.channel "game"
		@initialize()

		unless @keys?
			@triggerRandomDirection()
		else
			@scoresChannel.request 'set:display', @getDetails()

	initialize: ->
		@setDir 'stop'
		@trail = []
		@setNewPos()

	getType: ->
		'snake'

	getId: ->
		@id

	getKeys: ->
		@keys

	getDetails: ->
		id: @id
		lives: @lives
		score: @score
		playerName: @playerName
		color: @color
		keys: @keys

	getPosition: ->
		@trail

	getColor: ->
		@color

	hasPosition: (pos)->
		if pos?
			for item in @trail
				if item.x is pos.x and item.y is pos.y
					return true
		false

	setNewPos: ->
		@setPos
			x: Math.floor Math.random()*@boardSize
			y: Math.floor Math.random()*@boardSize

	handleKeydown: (keycode)->
		if @keys?
			switch keycode
				when @keys.left
					@setDir 'left'
				when @keys.up
					@setDir 'up'
				when @keys.right
					@setDir 'right'
				when @keys.down
					@setDir 'down'

	triggerRandomDirection: ->
		timeout = 1500*Math.random()
		setTimeout =>
			@setDir DIRECTIONS[Math.floor(Math.random()*4)]
			@triggerRandomDirection()
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
			when 'stop'
				@vel =
					x: 0
					y: 0

	isStopped: ->
		@vel.x is 0 and @vel.y is 0

	getNextPos: ->
		unless @frozen
			@setVelocity()
			unless @isStopped()
				{x, y} = @pos
				x += @vel.x
				y += @vel.y
				if x < 0 then x = @boardSize - 1
				if y < 0 then y = @boardSize - 1
				if x > @boardSize-1 then x = 0
				if y > @boardSize-1 then y = 0

				x:x
				y:y

	setPos: (pos)->
		@pos = pos if pos?
		@setTrail pos

	setTrail: (pos)->
		@trail.push pos if pos?
		while @trail.length > @tailSize
			@trail.shift()

	fail: ->
		unless @frozen
			@frozen = true
			@lives -= 1
			@playerStateChannel.trigger 'state:change',
				lives: @lives
			if @lives is 0
				@gameChannel.trigger 'game:end', @getId()
			else
				@initialize()
				setTimeout (=>
					@frozen = false
				), FAIL_TIMEOUT

	grow: ->
		@tailSize += 1

	updatePoints: (val)->
		if @id
			@score += val
			@playerStateChannel.trigger 'state:change',
				score: @score
