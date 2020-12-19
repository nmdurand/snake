import Marionette from 'backbone.marionette'

export default class BoardItem extends Marionette.MnObject
	initialize: (options)->
		console.log 'Initializing BoardItem with options', options

	getType: ->
		'item'

	getId: ->
		null

	getKeys: ->
		null

	draw: ->
		console.log 'Drawing item on board'

	getColor: ->
		console.log 'Returning color'

	getPosition: ->
		console.log 'Returning a list of all occupied positions'

	hasPosition: (pos)->
		console.log 'Checking if item has position', pos
