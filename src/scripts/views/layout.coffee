import Marionette from 'backbone.marionette'
import template from 'templates/layout'

import CanvasView from 'views/canvas'
import ScoresView from 'views/scores'

export default class GameLayoutView extends Marionette.View
	template: template
	className: 'gameLayout'

	regions:
		canvasRegion: '#canvasRegion'
		scoresRegion: '#scoresRegion'

	initialize: ->
		console.log 'Initializing GameLayoutView', @options

	onRender: ->
		canvasView = new CanvasView
		@showChildView 'canvasRegion', canvasView

		scoresView = new ScoresView
		@showChildView 'scoresRegion', scoresView
