import Marionette from 'backbone.marionette'
import template from 'templates/scores'

export default class ScoresView extends Marionette.View
	template: template
	className: 'scores'

	initialize: ->
		console.log 'Initializing ScoresView', @options
		{ @controller } = @options
