
TreeNode = require "./TreeNode.coffee"

class Tree
	constructor: (@items) ->
		@root = new TreeNode "root","root",@items

	treefy: (lst) ->
		delete @root.children if @root.children
		@root.items = @items
		@_treefy [@root],lst

	_treefy: (nodes, lst) ->
		return nodes if !lst.length
		attr = lst.shift()
		node.fillChildren attr for node in nodes
		cls = []
		for node in nodes
			for child in node.children
				child.parent =	node
				cls.push child
		# cls = (child for child in node.children for node in nodes)
		# cls =  _.union.apply null,cls
		@_treefy cls, lst
		return nodes

	tranverse: (nodefn, leaffn) ->
		@_tranverse @root,nodefn,leaffn

	_tranverse: (node, nodefn, leaffn) ->
		leaffn = nodefn if !leaffn
		resarr = if node.children then (@_tranverse child,nodefn,leaffn for child in node.children) else (leaffn.call item,item for item in node.items)
		console.log resarr
		return nodefn.call node,resarr

