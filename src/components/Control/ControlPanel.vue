
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
			<v-select :value.sync="selLst[$index]">
				<v-option v-for="key in attrLst" :value="key"></v-option>
			</v-select>
			<span class="pull-right" @click="remove($index)"><i class="fa fa-minus"></i><span>
		</div>
	<span>
			<span class="pull-right" @click="add"><i class="fa fa-plus"></i><span>
	</span>
	<div style="clear:both"></div>
</div>

<div class="group">
	<span class="name">Size By</span>
	<div class="vals">
		<v-select :value.sync="sizeBy" :placeholder="'size by'">
			<v-option v-for="attr in attrLst" :value="attr"></v-option>
		</v-select>
	</div>
	<div style="clear:both"></div>
</div>
<div class="group">
	<span class="name">Color By</span>
	<div class="vals">
		<v-select :value.sync="colorBy" :placeholder="'color by'">
			<v-option v-for="attr in attrLst" :value="attr"></v-option>
		</v-select>
	</div>
	<div style="clear:both"></div>
</div>

</div>

</template>

<script lang="coffee">

store = require "../../utils/ControlStore.coffee"
select = require("vue-strap").select
option = require("vue-strap").option

_ = require "underscore"

module.exports =
	components:
		vSelect: select
		vOption: option
	data:()->
		data: {}
		attrLst: []
		typeLst: []
		selLst: []
		curAttr: ""
		curView: "tree"
		colorBy: store.colorBy
		sizeBy: store.sizeBy
	events:
		event_load_data: (data)->
			@data = data
			@attrLst = data.schema.name
			@typelst = data.schema.type
	watch:
		curView: (name)->
			@$dispatch "event_control_change_view",name
		selLst: (sels)->
			res = _.uniq(sels.map (d)->d[0])
			@$dispatch "event_control_change_sellst",res
		sizeBy: (sels)->
			return if !sels.length
			@$dispatch "event_control_change_size_by",sels[0]
		colorBy: (sels)->
			return if !sels.length
			@$dispatch "event_control_change_color_by",sels[0]
	methods:
		add: ()->
			if @attrLst.length
				@selLst.push [@attrLst[0]]
		remove: (index)->
			@selLst.splice(index, 1)
		change: (index,val)->
			@selLst[index] = val
</script>

<style lang="stylus" src="../../css/cgroup.stylus"></style>

<style lang="stylus" scoped>

</style>
