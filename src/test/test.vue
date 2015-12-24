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
	compute:
		styleBaseTransform: ()->
			top = 20
			left = 20
			"translate("+top+","+left+")"
	ready: ()->
		d3.select("#testwrapper").attr("width",@width).attr("height",@height)
			.append("g").attr("transform",@styleBaseTransform)
	methods: {}


</script>

<style lang="stylus">

</style>
