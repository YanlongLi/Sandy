<template>

<div>
	<table class="table">
		<thead>
			<tr><th>Attribute Name</th><th>Attribute Value</th></tr>
		</thead>
		<tbody>
			<tr v-for="o in attrs">
				<td>{{o.key}}</td>
				<td>{{o.value}}</td>
			</tr>
		</tbody>
	</table>
</div>

</template>

<script lang="coffee">

choice = ["name","depth","x","y","size","dir","path","uid","gid","atime","ctime","mtime"]

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
			if typeof node.attr is 'function'
				lst.push {key:node.attr(),value:node.val()}
			lst

</script>

<style lang="stylus" scoped>


.table
	margin 0px
	thead
		th
			text-align center
	tbody
		td
			text-align center
			border-top 0px
			padding 4px

</style>
