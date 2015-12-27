<template>

<div>
	<div class="group">
		<span class="name">Tree Style</span>
		<div class="input-group vals">
			<input type="radio" v-model="curLayout" v-bind:value="'tree'" /> Tree
			<input type="radio" v-model="curLayout" v-bind:value="'radial'" /> Radial Tree
			<input type="radio" v-model="curLayout" v-bind:value="'cluster'" /> Cluster Tree
			<input type="radio" v-model="curLayout" v-bind:value="'radial_cluster'" /> Radial Cluster Tree
		</div>
		<div style="clear:both"></div>
	</div>
	<div class="group">
		<span class="name">Radius</span>
		<div class="input-group vals">
			<label>min(px)</label>
			<input type="number" v-model="radiusExtent[0]" min="1" max="20"/>
			<label>max(px)</label>
			<input type="number" v-model="radiusExtent[1]" min="5" max="20"/>
		</div>
		<div style="clear:both"></div>
	</div>
	<div class="group">
		<span class="name">Scale Type</span>
		<div class="input-group vals">
			<v-select :value.sync="scaleType">
				<v-option :value="'linear'"></v-option>
				<v-option :value="'log'"></v-option>
			</v-select>
		</div>
		<div style="clear:both"></div>
	</div>
</div>

</template>

<script lang="coffee">

d3 = require "d3"
$ = require "jquery"

select = require("vue-strap").select
option = require("vue-strap").option

module.exports=
	components:
		vSelect: select
		vOption: option
	data: () ->
		curLayout: "tree"
		scaleType: ["linear"]
		radiusExtent: [0,10]
	watch:
		curLayout: (layout)->
			@$dispatch "event_tree_change_layout",layout
		radiusExtent: (val)->
			@$dispatch "event_tree_change_radius_scale",val
	methods: {}

</script>

<style lang="stylus">

</style>
