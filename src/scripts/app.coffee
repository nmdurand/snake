import {Application} from 'backbone.marionette'

import GameController from 'engine/game'

export default class GameApp extends Application
	initialize: ->
		console.log 'Initializing app.'

	onStart: ->
		console.log 'App started.'

		controller = new GameController
			showView: @showView.bind @

		controller.start()
