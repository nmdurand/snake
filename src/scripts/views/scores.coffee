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
		@playerChannel = Radio.channel "player#{@model.get('id')}"

		@playerChannel.on 'lives:changed', (lives)=> @handleUpdateLives lives
		@playerChannel.on 'score:changed', (score)=> @handleUpdateScore score

		@model.on 'change', => @render()

	handleUpdateScore: (score)->
		@model.set 'score', score

	handleUpdateLives: (lives)->
		@model.set 'lives', lives

export default class ScoresView extends Marionette.CollectionView
	template: false
	className: 'scoreList'

	childView: ScoreItemView

	initialize: ->
		console.log 'Initializing ScoresView', @options
		{ @controller } = @options
		@collection = new Backbone.Collection

		@controller.updateStateDisplay = (statesDetails)=>
			@collection.reset statesDetails
