import Marionette from 'backbone.marionette'
import template from 'templates/layout'

import BoardView from 'views/board'
import ScoresView from 'views/scores'

export default class GameLayoutView extends Marionette.View
	template: template
	className: 'gameLayout'

	regions:
		boardRegion: '#boardRegion'
		scoresRegion: '#scoresRegion'

	initialize: ->
		console.log 'Initializing GameLayoutView', @options
		{ @controller } = @options

	onRender: ->
		boardView = new BoardView
			controller: @controller
		@showChildView 'boardRegion', boardView

		scoresView = new ScoresView
			controller: @controller
		@showChildView 'scoresRegion', scoresView
