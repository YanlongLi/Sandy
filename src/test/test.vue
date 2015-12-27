<template>

<div id="testwrapper">
	<svg></svg>
</div>

</template>

<script lang="coffee">

d3 = require "d3"
jquery = require "jquery"

module.exports=
	data: () ->
		width: 800
		height: 600
		data: []
		attrs: ["sepal_length","sepal_width","petal_legth","petal_width","class"]
		attrTypes: ["double","double","double","double","string"]
	asyncData: (resolve,reject)->
		that = @
		d3.csv "/data/iris.csv",(data)->
			resolve {data:data}
			that.computeInfo()
		return
	methods:
		computeInfo: ()->
			data = @data
			attrs = @attrs
			types = @attrTypes
			nest = d3.nest().key((d)->d.class)
				.key((d)->Math.floor(d.sepal_length))
				.rollup((ds)->
					ds.length
				).entries(data)
			@draw nest
		draw: (root)->
			layout = d3.layout.tree().size([@width,@height])
				.children((d)->d.values if d.values.length)
			rot = {key:"root",values:root}
			nodes = layout.nodes(rot)
			size = (d)->
				d.num = d.values if typeof d.values is "number"
				d.num = d3.sum(d.values,size)
				d.num
			size rot
			links = layout.links(nodes)
			console.log root
			base = d3.select("#testwrapper > svg > g")
			node = base.selectAll("g.node").data(nodes).enter().append('g')
				.attr("class","node").attr("transform",(d)->"translate("+d.x+","+d.y+")")
			node.append("circle").attr("r",(d)->
				if typeof d.values is "object"
					4
				else
					d.values / 2 + 1
			).attr("fill","#CCCCCC")
	compute:
		styleBaseTransform: ()->
			top = 20
			left = 20
			"translate("+top+","+left+")"
	ready: ()->
		d3.select("#testwrapper > svg").attr("width",@width).attr("height",@height)
			.append("g").attr("transform",@styleBaseTransform)


</script>

<style lang="stylus">

</style>
