import EventEmitter from 'events'

export default class BoardItem extends EventEmitter
	constructor: (options)->
		super()

	getType: ->
		'item'

	draw: ->
		console.log 'Drawing item on board'

	getColor: ->
		console.log 'Returning color'

	getPosition: ->
		console.log 'Returning a list of all occupied positions'

	hasPosition: (pos)->
		console.log 'Checking if item has position', pos
