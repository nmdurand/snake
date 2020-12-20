import Marionette from 'backbone.marionette'
import template from 'templates/layout'

import CanvasView from 'views/canvas'
import ScoresView from 'views/scores'

export default class GameLayoutView extends Marionette.View
	template: template
	className: 'gameLayout'

	regions:
		boardRegion: '#boardRegion'
		scoresRegion: '#scoresRegion'

	initialize: ->
		console.log 'Initializing GameLayoutView', @options
		{ @boardSize, @pixelSize } = @options

	onRender: ->
		boardView = new CanvasView
			boardSize: @boardSize
			pixelSize: @pixelSize
		@showChildView 'boardRegion', boardView

		scoresView = new ScoresView
		@showChildView 'scoresRegion', scoresView
