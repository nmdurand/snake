import BoardItem from 'boardItem'

DIRECTIONS = ['up','down','left','right']
FAIL_TIMEOUT = 1000

export default class Snake extends BoardItem
	constructor: (options)->
		super()
		{ @playerId, @playerName, @board, @color, @keys } = options
		@lives = 3
		@frozen = false
		@score = 0
		@initialize()

		if @keys?
			@setupScoreDisplay()
			@on 'keydown', (kc)=> @handleKeydown kc
		else
			@triggerNewDirection()

	initialize: ->
		@setDir 'stop'
		@trail = []
		@tailSize = 5
		@setNewPos()

	getType: ->
		'snake'

	draw: ->
		for pos in @trail
			@board.draw pos, @color

	hasPosition: (pos)->
		if pos?
			for item in @trail
				if item.x is pos.x and item.y is pos.y
					return true
		false

	setNewPos: ->
		@setPos
			x: Math.floor Math.random()*@board.getSize()
			y: Math.floor Math.random()*@board.getSize()

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
		unless @frozen
			@frozen = true
			@lives -= 1
			if @lives is 0
				@emit 'game:end'
			else
				@initialize()
				setTimeout (=>
					@frozen = false
				), FAIL_TIMEOUT

	grow: ->
		@tailSize += 1

	###### SCORE

	setupScoreDisplay: ->
		scoreList = document.getElementById "scoreList"
		player = document.createElement 'div'
		player.classList.add 'player'
		playerName = document.createElement 'div'
		playerName.classList.add 'playerName'
		playerName.innerHTML = @playerName + " / "
		scoreValue = document.createElement 'div'
		scoreValue.classList.add 'scoreValue'
		scoreValue.innerHTML = 0
		scoreValue.id = "player#{@playerId}-score"
		player.appendChild playerName
		player.appendChild scoreValue
		scoreList.append player

	updatePoints: (val)->
		if @playerId
			@score += val
			@updateScoreDisplay()

	updateScoreDisplay: ->
		scoreDiv = document.getElementById "player#{@playerId}-score"
		scoreDiv.innerHTML = @score
