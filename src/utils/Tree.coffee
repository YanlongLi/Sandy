
TreeNode = require("./TreeNode.coffee").TreeNode
prefix = require("./TreeNode.coffee").prefix
keys = require("./TreeNode.coffee").keys

class Tree
	constructor: (items) ->
		@[keys.items] = items
		@root = new TreeNode "root","root",@[keys.items]

	treefy: (lst) ->
		children = keys.children
		items = keys.items
		delete @root[children] if @root[children]
		@root[items] = @[items]
		@_treefy [@root],lst
		@root

	_treefy: (nodes, lst) ->
		return nodes if !lst.length
		attr = lst.shift()
		node.fillChildren attr for node in nodes
		cls = []
		for node in nodes
			for child in node[keys.children]
				child[keys.parent] =	node
				cls.push child
		# cls = (child for child in node.children for node in nodes)
		# cls =  _.union.apply null,cls
		@_treefy cls, lst
		return nodes

	tranverse: (nodefn, leaffn) ->
		@_tranverse @root,nodefn,leaffn

	_tranverse: (node, nodefn, leaffn) ->
		leaffn = nodefn if !leaffn
		resarr = if node[keys.children] then (@_tranverse child,nodefn,leaffn for child in node[keys.children]) else (leaffn.call item,item for item in node[keys.items])
		return nodefn.call node,resarr

module.exports =
	Tree:Tree
	prefix:prefix
	keys: keys
