import Marionette from 'backbone.marionette'
import Radio from 'backbone.radio'

import Snake from 'engine/items/snake'
import Apple from 'engine/items/apple'

export default class ItemController extends Marionette.MnObject
	initialize: (options)->
		console.log 'Initializing ItemController with options', options
		@config = require './config'
		@items = []
		@idGenerator = 0

		@canvasChannel = Radio.channel 'canvas'

	generateId: ->
		@idGenerator += 1

	register: (item)->
		@items.push item

	unregister: (id)->
		_.remove @items, (item)-> item.getId() is id

	populateGame: ->
		for item in @config
			switch item.type
				when 'snake'
					@addSnake item
				when 'apple'
					@addApple item

	addSnake: (opts)->
		opts.id = @generateId()
		@register new Snake opts

	addApple: (opts)->
		@register new Apple opts

	step: ->
		for item1 in @items
			if item1.getType() is 'snake'
				nextPos1 = item1.getNextPos()
				for item2 in @items
					if item2.getType() is 'apple'
						if item2.hasPosition nextPos1
							item1.grow()
							item1.updatePoints item2.getPoints()
							item2.setNewPos()
					else if item2.getType() is 'snake'
						if item2.hasPosition nextPos1
							item1.fail()
							nextPos1 = null
							break

				item1.setPos nextPos1

	drawItems: =>
		for item in @items
			@canvasChannel.request 'draw:canvas', item.getPosition(), item.getColor()

	hasActivePlayers: ->
		index = _.findIndex @items, (item)-> item.getKeys()?
		index isnt -1
