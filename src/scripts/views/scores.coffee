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
		@gameChannel = Radio.channel 'game'

		@gameChannel.on 'state:change', (id,state)=>
			if @model.get('id') is id
				@updateStateDisplay state

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

		@gameChannel = Radio.channel 'game'
		@gameChannel.reply 'set:state:display', (details)=>
			@collection.add details
