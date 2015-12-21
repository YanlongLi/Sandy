

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
	store.attrLst = [{key:"key1",name:"name1"},{key:"key2",name:"name2"},{key:"key3",name:"name3"},{key:"key4",name:"name4"}]
	store.selLst = []
	return store

store = DataStore()

module.exports = store
