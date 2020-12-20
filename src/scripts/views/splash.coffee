import Marionette from 'backbone.marionette'
import template from 'templates/splash'

export default class SplashView extends Marionette.View
	template: template
	className: 'splash'

	ui:
		startBtn: '#startButton'

	triggers:
		'click @ui.startBtn': 'start:game'

	initialize: ->
		console.log 'Initializing SplashView', @options
		{ @title, @message } = @options

	templateContext: ->
		title: @title
		message: @message
