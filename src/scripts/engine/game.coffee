
import Marionette from 'backbone.marionette'
import Radio from 'backbone.radio'

import CanvasController from 'engine/canvas'

import GameLayout from 'views/layout'
import _ from 'lodash'

import Snake from 'engine/items/snake'
import Apple from 'engine/items/apple'

boardSize = 40 # In 'pixels'
pixelSize = 20 # 'Pixels' size

export default class Game extends Marionette.MnObject
	initialize: ->
		console.log 'Initializing game controller.',@options
		{ @showView } = @options
		@items = []
		@idGenerator = 0
		@gameChannel = Radio.channel "game"

		@gameChannel.on 'game:end', (id)=> @handleGameEnd id

	generateId: ->
		@idGenerator += 1

	start: ->
		console.log 'Game started.'
		@showGame()
		@canvasController = new CanvasController
		@startGame()

	showGame: ->
		unless @layout?
			@layout = new GameLayout
				boardSize: boardSize
				pixelSize: pixelSize
		@showView @layout

	getItems: ->
		@items

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

		@addMachineSnakes 2
		@addApples 6

		document.addEventListener 'keydown', (e)=> @handleKeydown e
		@refreshInterval = setInterval (=> @refreshGame()), 1000/15

	addApples: (n)->
		for i in [1..n]
			@registerItem new Apple
				color: 'orange'
				boardSize: boardSize

	addMachineSnakes: (n)->
		for i in [1..n]
			@addSnake
				color: 'red'

	addSnake: (options)->
		opts =
			id: @generateId()
			playerName: options.playerName
			color: options.color
			keys: options.keys
			boardSize: boardSize
		snake = new Snake opts
		@registerItem snake

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
			@draw item.getPosition(), item.getColor()

	unregisterItem: (id)->
		@items = _.filter @items, (item)-> item.getId() isnt id

	hasActivePlayers: ->
		index = _.findIndex @items, (item)-> item.getKeys()?
		index isnt -1

	handleGameEnd: (id)->
		console.log 'Game ended for item:', id
		@unregisterItem id
		unless @hasActivePlayers()
			console.log 'THE END!!!'
			clearInterval @refreshInterval
