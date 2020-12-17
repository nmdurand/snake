import _ from 'lodash'

import Board from 'board'
import Snake from 'items/snake'
import Apple from 'items/apple'

boardSize = 40 # In 'pixels'
pxSize = 20 # 'Pixels' size

export default class App
	constructor: ->
		console.log 'Initializing app.'
		@items = []
		@idGenerator = 0

	generateId: ->
		@idGenerator += 1

	start: ->
		console.log 'Starting app.'
		canvas = document.getElementById 'canvas'
		canvas.setAttribute 'width', boardSize*pxSize
		canvas.setAttribute 'height', boardSize*pxSize
		ctx = canvas.getContext '2d'

		@board = new Board
			ctx: ctx
			boardSize: boardSize
			pixelSize: pxSize

		@addSnake
			playerName: 'Player 1'
			color: 'purple'
			keys:
				left: 37
				up: 38
				right: 39
				down: 40

		@registerItem new Snake
			playerId: 2
			playerName: 'Player 2'
			board: @board
			color: 'blue'
			keys:
				left: 81
				up: 90
				right: 68
				down: 83

		@registerItem new Snake
			board: @board
			color: 'red'

		@addApples 6

		document.addEventListener 'keydown', (e)=> @handleKeydown e
		@refreshInterval = setInterval (=> @refreshGame()), 1000/15

	addApples: (n)->
		for i in [1..n]
			@registerItem new Apple
				color: 'orange'
				board: @board

	addSnake: (options)->
		@registerItem new Snake
			id: @generateId()
			playerName: options.playerName
			board: @board
			color: options.color
			keys: options.keys

	handleKeydown: (e)->
		for item in @items
			if item.handleKeydown?
				item.handleKeydown e.which

	refreshGame: ->
		@board.erase()
		@step()
		@drawItems()

	registerItem: (item)->
		@items.push item
		item.on 'game:end', => @handleGameEnd()

	step: ->
		for item1 in @items
			if item1.getType() is 'snake'
				nextPos1 = item1.getNextPos()
				for item2 in @items
					if item2.getType() is 'apple'
						if item2.hasPosition nextPos1
							item1.grow()
							item1.updatePoints item2.getPoints()
							item2.setNewPos()
					else if item2.getType() is 'snake'
						if item2.hasPosition nextPos1
							item1.fail()
							nextPos1 = null
							break

				item1.setPos nextPos1

	drawItems: ->
		for item in @items
			item.draw()

	handleGameEnd: ->
		clearInterval @refreshInterval
		console.log 'Game ended !'
