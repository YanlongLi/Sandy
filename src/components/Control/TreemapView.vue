<template>

<div>
	<div class="group">
		<div class="name">Layout</div>
		<div class="vals">
			<div class="input-group">
				<div><input type="radio" v-model="control.layout" v-bind:value="'squarify'"/>Squarify</div>
				<div><input type="radio" v-model="control.layout" v-bind:value="'slice'"/>Slice</div>
				<div><input type="radio" v-model="control.layout" v-bind:value="'dice'"/>Dice</div>
				<div><input type="radio" v-model="control.layout" v-bind:value="'slice-dice'"/>Slice and Dice</div>
			</div>
		</div>
		<div style="clear:both"></div>
	</div>
	<div class="group">
		<div class="name"><div style="line-height:90px">Paddings</div></div>
		<div class="vals">
		<div class="box"><div>
			<div class="top"><input type="text" v-model="control.paddings[0]"></div>
			<div class="left"><input type="text" v-model="control.paddings[1]"></div>
			<div class="middle"></div>
			<div class="right"><input type="text" v-model="control.paddings[2]"></div>
			<div class="bottom"><input type="text" v-model="control.paddings[3]"></div>
		</div></div>
		</div>
		<div style="clear:both"></div>
	</div>
	<div class="group">
		<div class="name">Round</div>
		<div class="vals">
			<input type="checkbox" v-model="control.round"/>
		</div>
		<div style="clear:both"></div>
	</div>
	<div class="group">
		<div class="name">Sticky</div>
		<div class="vals">
			<input type="checkbox" v-model="control.sticky"/>
		</div>
		<div style="clear:both"></div>
	</div>
</div>

</template>

<script lang="coffee">

## used by viewSpecific

control = require("../../utils/ControlStore.coffee").treemap

module.exports=
	data: () ->
		control: control
	watch:
		"control.layout": (layout)->
			@$dispatch "event_control_treemap_change_layout",layout
		"control.paddings": (paddings)->
			@$dispatch "event_control_treemap_change_paddings",paddings.map Number
		"control.round": (round)->
			@$dispatch "event_control_treemap_change_round",round
		"control.sticky": (sticky)->
			@$dispatch "event_control_treemap_change_sticky",sticky

</script>

<style lang="stylus" scoped>

boxsize = 90px
cellsize = 30px

.box
	width boxsize
	height boxsize
	> div
		position relative
		left 0
		top 0
		width boxsize
		height boxsize
		input[type=text]
			width cellsize
			height cellsize
		div.top
			position absolute
			top 0
			left cellsize
			width cellsize
			height cellsize
		div.left
			position absolute
			top cellsize
			left 0
			width cellsize
			height cellsize
		div.middle
			position absolute
			top cellsize
			left cellsize
			width cellsize
			height cellsize
		div.right
			position absolute
			top cellsize
			right 0
			width cellsize
			height cellsize
		div.bottom
			position absolute
			bottom 0
			left cellsize
			width cellsize
			height cellsize

</style>
