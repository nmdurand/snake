
import Marionette from 'backbone.marionette'
import Radio from 'backbone.radio'

import GameLayout from 'views/layout'
import _ from 'lodash'

import ItemController from 'engine/itemController'

boardSize = 40 # In 'pixels'
pixelSize = 20 # 'Pixels' size

export default class GameController extends Marionette.MnObject
	initialize: ->
		console.log 'Initializing game controller.',@options
		{ @showView } = @options
		@itemController = new ItemController
		@gameChannel = Radio.channel 'game'
		@canvasChannel = Radio.channel 'canvas'

		@gameChannel.on 'game:end', (id)=> @handleGameEnd id
		@gameChannel.reply 'board:size', -> boardSize
		@gameChannel.reply 'pixel:size', -> pixelSize

	start: ->
		console.log 'Game started.'
		@showGame()
		@startGame()

	showGame: ->
		unless @layout?
			@layout = new GameLayout
		@showView @layout

	startGame: ->
		@itemController.populateGame()

		document.addEventListener 'keydown', (e)=>
			@gameChannel.trigger 'keydown', e.which
		@refreshInterval = setInterval (=> @refreshGame()), 1000/15

	refreshGame: ->
		@canvasChannel.request 'erase:canvas'
		@itemController.step()
		@itemController.drawItems()

	handleGameEnd: (id)->
		console.log 'Game ended for item:', id
		@itemController.unregister id
		unless @itemController.hasActivePlayers()
			console.log 'Game ended'
			clearInterval @refreshInterval
			@trigger 'game:end'
