<template>
<g>
<g class="grid" v-el="grid"></g>
<g class="link-group">
</g>
<g class="circle-group">
</g>
</g>

</template>

<script lang="coffee">

# http://jsfiddle.net/VividD/3TkJj/

$ = require "jquery"
d3 = require "d3"
keys = require("../../utils/Tree.coffee").keys

controlStore = require "../../utils/ControlStore.coffee"
control = controlStore.treeview
color = controlStore.color

module.exports=
	data:()->
		size = controlStore.getSize()
		[width,height] = [size.width,size.height]
		[diameter,duration] = [height,2000]
		#
		tree = d3.layout.tree().size([height, width])
		cluster = d3.layout.cluster().size([height, width])
		radialTree = d3.layout.tree().size([360, diameter / 2 ])
			.separation((a, b)-> if a.parent == b.parent then 1/a.depth else 2/a.depth)
		radialCluster = d3.layout.cluster().size([360, diameter / 2 ])
			.separation((a, b)-> if a.parent == b.parent then 1/a.depth else 2/a.depth)
		#
		diagonal = d3.svg.diagonal().projection((d)->[d.y, d.x])
		radialDiagonal = d3.svg.diagonal.radial()
			.projection((d)->[d.y, d.x / 180 * Math.PI])
		scale = d3.scale.linear()
		#
		root:{}
		width: width
		height: height
		diameter: diameter
		duration: duration
		tree: tree
		cluster: cluster
		radialTree: radialTree
		radialCluster: radialCluster
		diagonal:diagonal
		radialDiagonal: radialDiagonal
		layout: "tree" # "cluster","radialTree","radialCluster"
		scale: scale
	asyncData: (resolve, reject)->
		# @$http.get "/data/flare.json", (root)->
		# 	resolve root:root
		# 	@initEle()
		return
	watch:
		layout: (lname)->
			[dx,dy] = [0,0]
			switch lname
				when "tree"
					@drawTree()
				when "cluster"
					@drawTreeCluster()
				when "radial"
					dx = controlStore.size.width/2
					dy = controlStore.size.height/2
					@drawRadial()
				when "radial_cluster"
					dx = controlStore.size.width/2
					dy = controlStore.size.height/2
					@drawRadialCluster()
				else
					console.error "illegal layout name",lname
			@$dispatch "event_fix_position",dx,dy
	events:
		event_control_change_root: (root)->
			@root = root
			@root.x0 = controlStore.size.height/2
			@root.y0 = 0
			@initEle()
		event_control_change_color_by: (colorBy)->
			node = d3.select(@$el).select("g.circle-group").selectAll("g.node")
			node.select("circle").style("fill",(d)->
				if d[colorBy]
					domain = node.data().map (d)->d[colorBy]
					color.domain domain
					color(d[colorBy])
				else
					color(d[keys.val])
			)
		event_control_change_size_by: (sizeBy)->
			scale = @scale
			node = d3.select(@$el).select("g.circle-group").selectAll("g.node")
			node.select("circle").attr("r",(d)-> scale(d[sizeBy]) or 4)
		event_tree_change_layout: (layoutName)->
			@layout = layoutName
		event_tree_change_radius_scale: ([s1,s2])->
			scale = @scale.range([s1,s2])
			node = d3.select(@$el).select("g.circle-group").selectAll("g.node")
			node.select("circle").attr("r",(d)-> scale(d.size) or 4)
	methods:
		initEle: ()->
			i = 0
			root = @root
			layout = @tree
			radius = @diameter/2
			transform = (d)->"translate("+d.y+","+d.x+")"
			diagonal = @diagonal
			d3.select(@$el).select("g.circle-group").selectAll("g.node").remove()
			d3.select(@$el).select("g.link-group").selectAll("path.link").remove()
			@update(root,layout,@duration,transform,diagonal)
		drawTree: ()->
			root = @root
			layout = @tree
			duration = @duration
			radius = @diameter/2
			transform = (d)->"translate("+d.y+","+d.x+")"
			diagonal = @diagonal
			@update(root,layout,duration,transform,diagonal)
			return
		drawTreeCluster: ()->
			root = @root
			layout = @cluster
			duration = @duration
			radius = @diameter/2
			transform = (d)->"translate("+d.y+","+d.x+")"
			diagonal = @diagonal
			@update(root,layout,duration,transform,diagonal)
			return
		drawRadial: ()->
			root = @root
			layout = @radialTree
			duration = @duration
			transform = (d)->"rotate("+(d.x-90)+")translate("+(d.y)+")"
			diagonal = @radialDiagonal
			@update(root,layout,duration,transform,diagonal)
			return
		drawRadialCluster: ()->
			root = @root
			layout = @radialCluster
			duration = @duration
			transform = (d)->"rotate("+(d.x-90)+")translate("+(d.y)+")"
			diagonal = @radialDiagonal
			@update(root,layout,duration,transform,diagonal)
			return
		update: (nd,layout,duration,transform,diagonal)->
			nodes = layout.nodes @root
			links = layout.links nodes
			that = @
			range = controlStore.treeview.radius.map Number
			domain = d3.extent(nodes,(d)->
				if typeof d.size is 'number'
					d.size
				else if d.items and typeof d.items is 'array'
					d.size=d.items.length
				else
					0
			)
			scale = @scale.range(range).domain(domain)
			i = 0
			node = d3.select(@$el).select("g.circle-group")
				.selectAll("g.node").data(nodes,(d)->d.id or d.id = ++i)
			nodeEnter = node.enter().append("g").attr("class","node")
				.attr("transform",transform(nd))
			click = (d)->
				if d.children
					d._children = d.children
					delete d.children
					that.update(d,layout,duration,transform,diagonal)
				else if d._children
					d.children = d._children
					delete d._children
					that.update(d,layout,duration,transform,diagonal)
			nodeEnter.on("mouseover",(d)-> that.$dispatch "event_select_node",d)
				.on("click",click).append("circle").style("fill",(d)->
					if controlStore.colorBy.length
						colorBy = controlStore.colorBy[0]
						color(d[colorBy])
					else
						color(d[keys.val])
			).attr("r",(d)->scale(d.size) or 4)
			node.transition(duration).attr("transform",transform)
			node.exit().transition(duration).attr("transform",transform(nd)).remove()

			link = d3.select(@$el).select("g.link-group")
				.selectAll("path.link").data(links,(d)->d.target.id)
			link.enter().append("path").attr("class","link").attr("d",(d)->
				o = {x:nd.x0,y:nd.y0}
				diagonal({source:o,target:o})
			).attr("stroke","#0D95DA").attr("fill","none").attr("stroke-width",2)
			.attr("stroke-opacity",if control.labels then 0.8 else 0.2)
			link.transition(duration).attr("d",diagonal)
			link.exit().transition(duration).attr("d",(d)->
				o = {x:nd.x0,y:nd.y0}
				diagonal({source:o,target:o})
			).remove()
			nodes.forEach (d)->
				d.x0 = d.x
				d.y0 = d.y
	compiled: ()->
		size = controlStore.getSize()
		width = size.width * 5
		height = size.height * 5
		step = 40
		grid = d3.select(@$el).select(".grid")
		grid.append("g").selectAll("line").data(d3.range(-width,width,step)).enter()
			.append("line").attr("x1", (d)->d).attr("y1",-height)
			.attr("x2", (d)->d).attr("y2",height)
		grid.append("g").selectAll("line").data(d3.range(-height,height,step)).enter()
			.append("line").attr("y1", (d)->d).attr("x1",-width)
			.attr("y2", (d)->d).attr("x2",width)

</script>

<style lang="stylus" scoped>


.node
	circle
		fill #00A755
		stroke #CCCCCC
		stroke-width 1px


.grid
	line
		stroke-width 1px
		stroke #505050
		opacity 0.4


</style>
