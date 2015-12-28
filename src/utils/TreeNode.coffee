_ = require "underscore"

UniqID = (length = 8)->
	id = ""
	id += Math.random().toString().substr(2) while id.length < length
	id.substr 0,length

prefix = "__77479588__"

keys =
	attr: prefix+"attr"
	val: prefix+"val"
	items: "items"
	children: "children"
	parent: prefix+"parent"

class TreeNode

	constructor: (attr, val, items) ->
		@[keys.attr] = attr
		@[keys.val] = val
		@[keys.items] = items
		return

	fillChildren: (attr) ->
		obj = {}
		_.each @[keys.items], (item, idx)->
			val = item[attr]
			obj[val] = [] if !obj[val]
			obj[val].push item
			return
		@[keys.children] = (new TreeNode attr,val,items for val,items of obj)
		# delete @items
		return

	attr: ()-> @[keys.attr]
	val: ()-> @[keys.val]

module.exports =
	prefix: prefix
	TreeNode:TreeNode
	keys: keys
