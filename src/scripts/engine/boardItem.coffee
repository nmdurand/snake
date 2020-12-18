import EventEmitter from 'events'

export default class BoardItem extends EventEmitter
	constructor: (options)->
		super()

	getType: ->
		'item'

	draw: ->
		console.log 'Drawing item on board'

	hasPosition: (pos)->
		console.log 'Checking if item has position', pos
