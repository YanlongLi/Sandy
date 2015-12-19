<template>
<g>
<g class="grid" v-el="grid"></g>
	<g class="circle-group">
		<circle r="4" cx="200" cy="300"></circle>
		<!--<nodecomp v-for="node in nodes" :node="node" :radius="radius(node)" :style="style(node)"></nodecomp>-->
	</g>
	<g class="link-group">
	</g>
</g>

</template>

<script lang="coffee">

$ = require "jquery"
d3 = require "d3"

controlStore = require "../utils/ControlStore.coffee"

module.exports=
	data:()->
		size = controlStore.getSize()
		[width,height] = [size.width,size.height]
		[diameter,duration] = [width,2000]
		#
		tree = d3.layout.tree().size([height, width - 160])
		cluster = d3.layout.cluster().size([height, width - 160])
		radialTree = d3.layout.tree().size([360, diameter / 2 ])
			.separation((a, b)-> if a.parent == b.parent then 1/a.depth else 2/a.depth)
		radialCluster = d3.layout.cluster().size([360, diameter / 2 ])
			.separation((a, b)-> if a.parent == b.parent then 1/a.depth else 2/a.depth)
		#
		diagonal = d3.svg.diagonal().projection((d)->[d.y-diameter/2, d.x-diameter/2])
		radialDiagonal = d3.svg.diagonal.radial()
			.projection((d)->[d.y, d.x / 180 * Math.PI])
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
	asyncData: (resolve, reject)->
		@$http.get "/data/flare.json", (root)->
			resolve root:root
			@initEle()
			that = @
			setInterval ()->
				names = ["tree","cluster","radialTree","radialCluster"]
				index = Math.round(Math.random()*3)
				console.log "change layout",index,names[index]
				that.layout = names[index]
			,3000
		return
	watch:
		layout: (lname)->
			switch lname
				when "tree"
					@drawTree()
				when "cluster"
					@drawTreeCluster()
				when "radialTree"
					@drawRadial()
				when "radialCluster"
					@drawRadialCluster()
				else
					console.error "illegal layout name",lname
	events:
		event_tree_change_layout: (layoutName)->
			@layout = layoutName
	methods:
		initEle: ()->
			i = 0
			root = @root
			layout = @tree
			radius = @diameter/2
			transform = (d)->"translate("+(d.y-radius)+","+(d.x-radius)+")"
			# transform = (d)->"translate("+d.y+","+d.x+")"
			diagonal = @diagonal
			nodes = layout.nodes root
			links = layout.links nodes
			scale = d3.scale.linear().domain(d3.extent(nodes,(d)->d.size)).range([3,10])
			node = d3.select(@$el).select("g.circle-group").selectAll("g.node")
				.data(nodes,(d)->d.id || d.id=++i).enter().append("g").attr("class","node")
				.attr("transform",transform)
			node.insert("circle","g").style("stroke","#e41a1c").attr("r",(d)->scale(d.size) or 4)
			link = d3.select(@$el).select("g.link-group").selectAll("path.link")
				.data(links, (d)->d.target.id).enter().append("path").attr("class","link")
				.attr("d",diagonal).style("fill","none").style("stroke","red")
		drawTree: ()->
			root = @root
			layout = @tree
			duration = @duration
			radius = @diameter/2
			transform = (d)->"translate("+(d.y-radius)+","+(d.x-radius)+")"
			diagonal = @diagonal
			@update(root,layout,duration,transform,diagonal)
			return
		drawTreeCluster: ()->
			root = @root
			layout = @cluster
			duration = @duration
			radius = @diameter/2
			transform = (d)->"translate("+(d.y-radius)+","+(d.x-radius)+")"
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
		update: (root,layout,duration,transform,diagonal)->
			nodes = layout.nodes root
			links = layout.links nodes
			node = d3.select(@$el).select("g.circle-group").selectAll("g.node")
			node.data(nodes,(d)->d.id).transition(duration).attr("transform",transform)
			link = d3.select(@$el).select("g.link-group").selectAll("path.link")
			link.data(links,(d)->d.target.id).transition(duration).attr("d",diagonal)
		temp: ()->
			size = controlStore.getSize()
			width = size.width
			height = size.height
			layout = d3.layout.tree().size([2*height,2*width])
			diagonal = d3.svg.diagonal().projection((d)->[d.y, d.x])
			@root.x0 = 0
			@root.y0 = 0
			nodes = layout.nodes(@root)
			links = layout.links(nodes)
			scale = d3.scale.linear().domain(d3.extent(nodes,(d)->d.size))
				.range([3,10])
			nodes.forEach (d)-> d.y = d.depth * 180
			i = 0
			node = d3.select(@$el).select("g.circle-group").selectAll("g.node")
				.data(nodes,(d)->d.id || d.id=++i)
			nodeEnter = node.enter().append("g").attr("class","node")
				.attr("transform", (d)->"translate("+d.y+","+d.x+")")
			nodeEnter.append("circle").attr("r",(d)->
				return 4 if d.children
				return scale(d.size)
			)
			nodeEnter.append("text").text((d)->d.name)
				.attr("text-anchor",(d)->d.children?"end":"start")
				.attr("dx", (d)->d.children?-10:10)
			that = @
			node.on "click",(d)->
				that.$dispatch "event_node_select",d
			link = d3.select(@$el).select("g.link-group").selectAll("g.link")
				.data(links, (d)->d.target.id)
			link.enter().insert("path","g").attr("class","link")
				.attr("d",diagonal).style("fill","none")
		
</script>

<style lang="stylus">

.node
	circle
		fill red
		stroke #CCCCCC
		stroke-width 1px

path.link
	fill none
	stroke #CCCCCC
	stroke-width 1px

.grid
	line
		stroke-width 1px
		stroke #505050
		opacity 0.4


</style>
