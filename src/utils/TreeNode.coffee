class TreeNode

	constructor: (@_attr, @_val, @items) ->
		return

	fillChildren: (attr) ->
		obj = {}
		_.each @items, (item, idx)->
			val = item[attr]
			obj[val] = [] if !obj[val]
			obj[val].push item
			return
		@children = (new TreeNode attr,val,items for val,items of obj)
		delete @items
		return
