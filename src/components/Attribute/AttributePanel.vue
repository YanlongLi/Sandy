<template>

<div>
	Name: {{curNode.name}}
	<br>
	Depth: {{curNode.depth}}
</div>

</template>

<script lang="coffee">

module.exports=
	data: ()->
		curNode:
			name: "no name"
			depth: "no depth"
	events:
		event_select_node: (node)->
			@curNode = node

</script>

<style lang="stylus">

</style>
