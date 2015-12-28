<template>

<div>
	<div v-for="o in attrs">
		<span>{{o.key}}</span>
		<span>{{o.value}}</span>
	</div>
</div>

</template>

<script lang="coffee">

choice = ["name","depth","x","y","size"]

module.exports=
	data: ()->
		curNode:null
	events:
		event_select_node: (node)->
			@curNode = node
	computed:
		attrs: ()->
			return [] if !@curNode?
			node = @curNode
			lst = ({key:at,value:node[at]} for at in choice).filter (d)->d.value?
			if node.attr()
				lst.push {key:node.attr(),value:node.val()}
			lst

</script>

<style lang="stylus">

</style>
