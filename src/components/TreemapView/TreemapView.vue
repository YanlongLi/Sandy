<template>

<g>
	<g class="cells"></g>
</g>

</template>

<script lang="coffee">

$ = require "jquery"
d3 = require "d3"

control = require "../../utils/ControlStore.coffee"

module.exports =
	data:()->
		size = control.getSize()
		color = d3.scale.category20c()
		sizeBy = (d)->d.size
		root: {}
		sizeBy: sizeBy
		colorBy: (d)->color(d.name)
		curRoot: {}
		size: size
		layout: d3.layout.treemap().sticky(false)
			.size([size.width,size.height])
			.value(sizeBy)
		nodes: []
		dragSet: false
	asyncData: (resolve,reject)->
		@$http.get "/data/wifivis.json", (root)->
			resolve root:root
		return
	watch:
		sizeBy: (nf)->
			@layout.value(nf)
		layout: (lay)->
			@nodes = lay.nodes @root
		root: (root)->
			@nodes = @layout.nodes @root
		nodes: (nodes)->
			that = @
			cells = d3.select(@$el).select("g.cells")
				.selectAll("g.cell").data(nodes)
			cells.exit().remove()
			cells = cells.enter()
				.append("g").attr("class","cell")
				.attr("transform", (d)->"translate("+d.x+","+d.y+")")
				.on("click",(d)->
					return if that.dragSet
					if that.curRoot == d.parent
						that.curRoot = that.root
					else
						that.curRoot=d.parent
				)
			cells.append("rect")
				.attr("width", (d)->d.dx-1)
				.attr("height", (d)->d.dy-1)
				.attr("fill", @colorBy)
			# cells.append("text").text((d)->d.name)
			return
		curRoot: (cur)-> ## draw treemap
			size = @size
			[w,h] = [size.width,size.height]
			xScale = d3.scale.linear().range([0,w])
			yScale = d3.scale.linear().range([0,h])
			xScale.domain [cur.x,cur.x+cur.dx]
			yScale.domain [cur.y,cur.y+cur.dy]
			[kx,ky] = [w/cur.dx,h/cur.dy]
			cells = d3.select(@$el).select("g.cells").selectAll("g.cell")
				.transition(1000).attr("transform", (d)->"translate("+xScale(d.x)+","+yScale(d.y)+")")
			cells.select("rect")
				.attr("width",(d)->kx*d.dx)
				.attr("height",(d)->ky*d.dy)
	methods:
		onNodeSelect: ()->
			@$dispatch "event_select_node",{name:"node",depth:2}
	ready: ()->
		that = @
		@$on "event_drag_set",(v)->
			that.dragSet = v
</script>

<style lang="stylus" scoped>


</style>
