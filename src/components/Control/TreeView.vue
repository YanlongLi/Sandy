<template>

<div>
	<fieldset>
		<legend>Tree Style</legend>
		<div class="input-group">
			<input type="radio" v-model="curLayout" v-bind:value="'tree'" /> Tree
			<input type="radio" v-model="curLayout" v-bind:value="'radial'" /> Radial Tree
			<input type="radio" v-model="curLayout" v-bind:value="'cluster'" /> Cluster Tree
			<input type="radio" v-model="curLayout" v-bind:value="'radial_cluster'" /> Radial Cluster Tree
		</div>
	</fieldset>
</div>

</template>

<script lang="coffee">

module.exports=
	data: () ->
		curLayout: "tree"
	watch:
		curLayout: (layout)->
			@$dispatch "event_tree_change_layout",layout
	methods: {}

</script>

<style lang="stylus">

</style>
