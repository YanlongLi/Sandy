
<template>

<g>
	<g></g>
</g>

</template>

<script lang="coffee">

controlStore = require "../../utils/ControlStore.coffee"

require "../../utils/d3.layout.indent.js"

module.exports=
	data: ()->
		root:{}
		size: controlStore.getSize()
		barWidth: 200
		barHeight: 20
		color : d3.scale.category20c()
	asyncData: (resolve, reject)->
		@$http.get "/data/flare.json", (root)->
			resolve root:root
			@initEle()
		return
	methods:
		initEle: ()->
			root = @root
			@update root
		update: ()->
			that = @
			root = @root
			color = @color
			layout = d3.layout.indent().nodeSize([@barHeight, @barHeight])
			  .separation((a, b)->if a.children then 2 else 1)
			nodes = layout.nodes(root)
			node = d3.select(@$el).select("g").selectAll("g.ele")
				.data(nodes)
			nodeEnter = node.enter().append("g").attr("class","ele")
			nodeEnter.attr("transform",(d)->
				return "translate(0,0)" if !d.parent
				"translate("+d.parent.x+","+d.parent.y+")"
				)
			nodeEnter.append("rect")
			nodeEnter.append("text")
			node.select("rect").attr("width",(d)->that.barWidth-d.x).attr("height",@barHeight)
				.attr("fill",(d)->color(d.name))
			node.select("text").text((d)->d.name)
			node.transition(750).attr("transform",(d)->"translate("+d.x+","+d.y+")")
			node.exit().remove()
			node.on "click",(d)->
				return if !d.children && !d._children
				if d.children
					d._children = d.children
					d.children = null
				else
					d.children = d._children
					d._children = null
				that.update(d)

</script>

<style lang="stylus">

</style>
