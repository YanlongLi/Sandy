
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
</div>

</template>

<script lang="coffee">

attrSelect = require "./attrSelect.vue"
controlStore = require "../../utils/ControlStore.coffee"

module.exports =
	components:
		attrSelect: attrSelect
	data:()->
		attrLst: controlStore.attrLst
		selLst: controlStore.selLst
		curAttr: ""
		curView: "tree"
	watch:
		curView: (name)->
			@$dispatch "event_change_view",name
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
