
<template>
<div>
<div class="group">
	<span class="name">Current View</span>
	<span class="input-group vals">
		<input type="radio" v-model="curView" v-bind:value="'tree'" /> Tree View
		<input type="radio" v-model="curView" v-bind:value="'treemap'" /> Treemap View
		<input type="radio" v-model="curView" v-bind:value="'icicle'" /> Icicle View
		<input type="radio" v-model="curView" v-bind:value="'indent'" /> Indent View
	</span>
	<div style="clear:both"></div>
</div>

<div class="group">
	<span class="name">Group By</span>
	<span class="vals">
		<div v-for="attr in selLst" track-by="$index">
			<attr-select :lst="attrLst" :val="+attr" :idx="$index" @item_change="change"></attr-select>
			<span class="pull-right" @click="remove($index)"><i class="fa fa-minus"></i><span>
		</div>
		<div>
			<span class="pull-right" @click="add"><i class="fa fa-plus"></i><span>
		</div>
	</span>
	<div style="clear:both"></div>
</div>

<div class="group">
	<span class="name">Size By</span>
	<div class="vals">
		<v-select :value.sync="sizeBy" :placeholder="'size by'">
			<v-option v-for="attr in attrLst" :value="attr.name"></v-option>
		</v-select>
	</div>
	<div style="clear:both"></div>
</div>
<div class="group">
	<span class="name">Color By</span>
	<div class="vals">
		<v-select :value.sync="colorBy" :placeholder="'color by'">
			<v-option v-for="attr in attrLst" :value="attr.name"></v-option>
		</v-select>
	</div>
	<div style="clear:both"></div>
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
	margin-bottom 10px
	.name
		width 80px
		font-weight bold
		float left
		text-align right
	.vals
		float right
		width 200px
		select
			width 160px
			height 26px
			line-height 26px
			margin-bottom 6px

</style>
