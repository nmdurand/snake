
import Marionette from 'backbone.marionette'

import CanvasController from 'engine/canvas'

import GameLayout from 'views/layout'
import _ from 'lodash'

# import Board from 'engine/board'
import Snake from 'engine/items/snake'
import Apple from 'engine/items/apple'

boardSize = 40 # In 'pixels'
pxSize = 20 # 'Pixels' size

export default class Game extends Marionette.MnObject
	initialize: ->
		console.log 'Initializing game controller.',@options
		{@showView} = @options
		@items = []
		@idGenerator = 0

	generateId: ->
		@idGenerator += 1

	start: ->
		console.log 'Game started.'
		@showGame()
		@canvasController = new CanvasController
			controller: @
		@startGame()

	showGame: ->
		unless @layout?
			@layout = new GameLayout
				controller: @
		@showView @layout

	getBoardSize: ->
		boardSize
	getPixelSize: ->
		pxSize

	draw: (args...)->
		@canvasController.draw args...

	startGame: ->
		@addSnake
			playerName: 'Player 1'
			color: 'purple'
			keys:
				left: 37
				up: 38
				right: 39
				down: 40

		@addSnake
			playerName: 'Player 2'
			color: 'blue'
			keys:
				left: 81
				up: 90
				right: 68
				down: 83

		@addSnake
			color: 'red'

		@addApples 6

		document.addEventListener 'keydown', (e)=> @handleKeydown e
		@refreshInterval = setInterval (=> @refreshGame()), 1000/15

	addApples: (n)->
		for i in [1..n]
			@registerItem new Apple
				color: 'orange'
				controller: @

	addSnake: (options)->
		console.log 'Adding snake', options
		opts =
			id: @generateId()
			playerName: options.playerName
			color: options.color
			keys: options.keys
			controller: @
		@registerItem new Snake(opts)

	handleKeydown: (e)->
		for item in @items
			if item.handleKeydown?
				item.handleKeydown e.which

	refreshGame: ->
		@canvasController.erase()
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
							# item1.updatePoints item2.getPoints()
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
