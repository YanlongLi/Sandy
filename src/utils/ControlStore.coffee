

$ = require "jquery"

DataStore = ()->
	store = {}
	##
	size =
		width: 800
		height: 600
	store.getSize = ()->
		size
	store.setSize = (s)->
		if s.width
			size.width = s.width
		if s.height
			size.height = s.height
	##
	store.attrLst = ["name1","name2","name3","name4","name5"]
	store.selLst = []
	return store

store = DataStore()

module.exports = store
