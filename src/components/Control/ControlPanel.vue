
<template>
<div>
<div class="row group">
	<p>Current View</p>
	<div class="input-group">
		<input type="radio" v-model="curView" v-bind:value="'tree'" /> Tree View
		<input type="radio" v-model="curView" v-bind:value="'treemap'" /> Treemap View
		<input type="radio" v-model="curView" v-bind:value="'icicle'" /> Icicle View
		<input type="radio" v-model="curView" v-bind:value="'indent'" /> Indent View
	</div>
</div>

<div class="row group">
	<div class="col-md-3 left">Group By</div>
	<div class="col-md-9 right">
		<div v-for="attr in selLst" track-by="$index">
			<attr-select :lst="attrLst" :val="+attr" :idx="$index" @item_change="change"></attr-select>
			<span class="pull-right" @click="remove($index)"><i class="fa fa-minus"></i><span>
		</div>
		<div>
			<span class="pull-right" @click="add"><i class="fa fa-plus"></i><span>
		</div>
	</div>
</div>

<div class="row group">
	<div class="col-md-3 left">Size By</div>
	<div class="col-md-9 right">
		<v-select :value.sync="sizeBy" :placeholder="'size by'">
			<v-option v-for="attr in attrLst" :value="attr.name"></v-option>
		</v-select>
	</div>
</div>
<div class="row group">
	<div class="col-md-3 left">Color By</div>
	<div class="col-md-9 right">
		<v-select :value.sync="colorBy" :placeholder="'color by'">
			<v-option v-for="attr in attrLst" :value="attr.name"></v-option>
		</v-select>
	</div>
</div>

</div>

</template>

<script lang="coffee">

attrSelect = require "./attrSelect.vue"
controlStore = require "../../utils/ControlStore.coffee"
select = require("vue-strap").select
option = require("vue-strap").option

module.exports =
	components:
		attrSelect: attrSelect
		vSelect: select
		vOption: option
	data:()->
		attrLst: controlStore.attrLst
		selLst: controlStore.selLst
		curAttr: ""
		curView: "tree"
		colorBy: []
		sizeBy: []
	watch:
		curView: (name)->
			@$dispatch "event_control_change_view",name
		sizeBy: (sels)->
			return if !sels.length
			@$dispatch "event_control_change_size_by",sels[0]
		colorBy: (sels)->
			return if !sels.length
			@$dispatch "event_control_change_color_by",sels[0]
	methods:
		add: ()->
			@selLst.push 0
		remove: (index)->
			@selLst.splice(index, 1)
		change: (index,val)->
			@selLst[index] = val
</script>


<style lang="stylus" scoped>

.group
	border-bottom 1px dotted #333333
	margin-bottom 10px
	line-height 32px
	.left
		text-align left 
		font-size 12px
	.right
		div
			span
				line-height 32px
		select
			width 90%
			height 32px
			margin 0 0 10px
			padding-left 10px
			padding-right 30px

</style>
