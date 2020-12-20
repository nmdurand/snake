import Marionette from 'backbone.marionette'
import Backbone from 'backbone'
import Radio from 'backbone.radio'

import template from 'templates/scores'
import itemTemplate from 'templates/scores/item'

class ScoreItemView extends Marionette.View
	template: itemTemplate
	className: 'scoreItem'

	initialize: ->
		console.log 'Initializing ScoreItemView', @options
		@playerStateChannel = Radio.channel "state:#{@model.get('id')}"

		@playerStateChannel.on 'state:change', (state)=> @updateStateDisplay state

		@model.on 'change', => @render()

	updateStateDisplay: (state)->
		@model.set state

export default class ScoresView extends Marionette.CollectionView
	template: false
	className: 'scoreList'

	childView: ScoreItemView

	initialize: ->
		console.log 'Initializing ScoresView', @options
		@collection = new Backbone.Collection

		@scoresChannel = Radio.channel 'scores'
		@scoresChannel.reply 'set:display', (details)=>
			@collection.add details
