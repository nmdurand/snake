import Marionette from 'backbone.marionette'
import Backbone from 'backbone'

import template from 'templates/scores'
import itemTemplate from 'templates/scores/item'

class ScoreItemView extends Marionette.View
	template: itemTemplate
	className: 'scoreItem'

	initialize: ->
		# console.log 'Initializing ScoreItemView', @options


export default class ScoresView extends Marionette.CollectionView
	template: template
	className: 'scoreList'

	childView: ScoreItemView

	initialize: ->
		console.log 'Initializing ScoresView', @options
		{ @controller } = @options
		@collection = new Backbone.Collection

		@controller.updateStateDisplay = (statesDetails)=>
			@collection.reset statesDetails
