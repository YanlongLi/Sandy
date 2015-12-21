<template>
<g>
	<g class="icicle"></g>
	<g class="sunburst"></g>
</g>
</template>

<script lang="coffee">

$ = require "jquery"
d3 = require "d3"

controlStore = require "../../utils/ControlStore.coffee"

module.exports=
	data: ()->
		size = controlStore.getSize()
		root: {}
		size: size
		isRadial: false
	computed:
		radius: ()-> Math.min(@size.width,@size.height)/2
	asyncData: (resolve, reject)->
		@$http.get "/data/flare.json", (root)->
			resolve root:root
			console.log root
			@drawSunburst()
		return
	methods:
		drawIcicle: ()->
			[w,h] = [@size.width, @size.height]
			that = @
			root= @root
			[x,y] = (d3.scale.linear().range([0,l]) for l in [w,h])
			color = d3.scale.category20c()
			partition = d3.layout.partition().value((d)->d.size)
			nodes = partition(root)
			node = d3.select(@$el).select("g.icicle").selectAll("g.frame")
				.data(nodes).enter().append("g").attr("class","frame")
				.attr("transform",(d)->"translate("+x(d.x)+","+y(d.y)+")")
			node.append("rect")
				.attr('width', (d)->x(d.dx))
				.attr('height', (d)->y(d.dy))
				.attr("fill", (d)->color(d.name))
			node.append("text").text((d)->d.name)
			# node.on "mouseover",(d)->
			# 	console.log "on hover"
			# 	that.$dispatch "event_select_node",d
			# node.on "click",(d)->
			# 	x.domain([d.x,d.x+d.dx])
			# 	y.domain([d.y,1]).range([0,h])
			# 	d3.select(that.$el).selectAll("g.frame")
			# 		.transition().duration(750)
			# 		.attr("transform",(d)->"translate("+x(d.x)+","+y(d.y)+")")
			# 		.attr('width', (d)->x(d.x+d.dx)-x(d.x))
			# 		.attr('height', (d)->y(d.y+d.dy)-y(d.y))
			return
		drawSunburst: ()->
			root= @root
			radius = @radius
			x = d3.scale.linear().range([0, 2 * Math.PI])
			y = d3.scale.linear().range([0, radius])
			color = d3.scale.category20c()
			partition = d3.layout.partition().value((d)->d.size)
			arc = d3.svg.arc()
				.startAngle((d)->Math.max(0,Math.min(2*Math.PI,x(d.x))))
				.endAngle((d)->Math.max(0,Math.min(2*Math.PI,x(d.x+d.dx))))
				.innerRadius((d)->Math.max(0,y(d.y)))
				.outerRadius((d)->Math.max(0,y(d.y+d.dy)))
			rotate = (d)->(x(d.x + d.dx / 2) - Math.PI / 2) / Math.PI * 180
			nodes = partition.nodes(root)
			that = @
			node = d3.select(@$el).select("g.sunburst").selectAll("g.path")
				.data(nodes)
			nodeEnter = node.enter().append("g").attr("class","path")
			nodeEnter.append("path").attr("d",arc).style("fill", (d)->color(d.name))
			nodeEnter.append("text").attr("transform",(d)->"rotate("+rotate(d)+")")
				.attr("x",(d)->y(d.y)).attr("dx","6").attr("dy",".35em").text((d)->d.name)
			node.on "mouseover",(d)->
				that.$dispatch "event_select_node",d
			return

</script>

<style lang="stylus">

</style>
