import {Application} from 'backbone.marionette'

import GameController from 'engine/game'
import SplashView from 'views/splash'

export default class GameApp extends Application
	initialize: ->
		console.log 'Initializing app.'

	onStart: ->
		console.log 'App started.'
		@showStartSplash()

	showStartSplash: ->
		splashView = new SplashView
			title: 'SNAKE'
			message: 'Click START to play'
		splashView.on 'start:game', => @startGame()

		@showView splashView

	startGame: ->
		controller = new GameController
			showView: @showView.bind @

		controller.start()
		controller.on 'game:end', => @showGameEndSplash()

	showGameEndSplash: ->
		splashView = new SplashView
			title: 'GAME OVER'
			message: 'Click START to play again'
		splashView.on 'start:game', => @startGame()

		@showView splashView
