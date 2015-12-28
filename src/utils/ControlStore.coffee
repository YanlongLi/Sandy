
color = d3.scale.category20c()

treeview =
	radius: [2,20]

store =
	size:
		width: 800
		height: 600
	fix:
		dx:0
		dy:0
	pos:
		dx:20
		dy:20
		scale:0.8
	setSize: (size)->
		@size.width = size.width
		@size.height = size.height
	getSize: ()-> @size
	#
	color: color
	colorBy: []
	sizeBy: []
	#
	treeview: treeview

module.exports = store
