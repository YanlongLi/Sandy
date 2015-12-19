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
		root:{}
	asyncData: (resolve, reject)->
		@$http.get "/data/flare.json", (root)->
			resolve root:root
			@drawTree()
		return
	methods:
		drawTree: ()->
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
