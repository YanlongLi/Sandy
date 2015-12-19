<template>
<div class="wrapper">
	<div class="toolbar">
		<span :class="{'btn-primary-outline':!dragSet, 'btn-primary':dragSet}" @click="toggleDrag"><i class="fa fa-arrows"></i></span>
		<span>Scale: {{Math.floor(trans.scale*100)}}</span>
	</div>
	<div class="panel-wrapper">
		<div class="panel">
			<div class="panel-header">Control Panel</div>
			<div class="panel-body">
				<control-panel @event_change_view="onViewChange"></control-panel>
			</div>
		</div>
		<div class="panel">
			<div class="panel-header">Attribute Panel</div>
			<div class="panel-body">
				<attribute-panel :cur-node="curNode"></attribute-panel>
			</div>
		</div>
	</div>
	<div class="view-wrapper" @mouseup="divMouseUp" @mousedown="divMouseDown" @mousemove="divMouseMove" @wheel="divMouseWheel">
		<svg width="100%" height="100%">
			<g class="view" :transform="transform">
				<component :is="curView" @event_node_select="onNodeSelect" keep-alive ></component>
			</g>
		</svg>
	</div>
</div>

</template>

<script lang="coffee">

d3 = require "d3"
$ = require "jquery"

treeview = require "../components/treeView.vue"
treemapview = require "../components/treemapView.vue"
icicleview = require "../components/icicleView.vue"
indentview = require "../components/indentView.vue"

control = require "../components/controlPanel.vue"
attribute = require "../components/attributePanel.vue"

module.exports=
	components:
		treeView: treeview
		treemapView: treemapview
		icicleView: icicleview
		indentView: indentview
		controlPanel: control
		attributePanel: attribute
	data: ()->
		dragSet: false
		scaleSet: false
		isMouseDown: false
		trans:
			dx:20
			dy:20
			scale:0.8
		curNode:
			name: "no name"
			depth: "no depth"
		curView: "treeView"
	methods:
		onViewChange: (viewName)->
			@curView = viewName
		onNodeSelect: (node)->
			@$set "curNode",node
		toggleDrag: ()->
			@dragSet=!@dragSet
			@$broadcast "event_drag_set",@dragSet
		resetPos: ()->
			@trans.scale = 0.8
			@trans.dx = 20
			@trans.dy = 20
		divMouseWheel: (event)->
			getD = (dx,os,ns,xoff)-> (xoff*(os-ns)+dx*ns)/os
			return if !@dragSet
			oS = @trans.scale
			nS = oS + (event.wheelDelta / 1200.0)
			@trans.dx = getD @trans.dx,oS,nS,event.offsetX
			@trans.dy = getD @trans.dy,oS,nS,event.offsetY
			@trans.scale = nS
		divMouseDown: ()->
			return if !@dragSet
			@isMouseDown = true
		divMouseUp: ()->
			return if !@dragSet
			@isMouseDown = false
		divMouseMove: (event)->
			return if !@dragSet or !@isMouseDown
			@trans.dx += event.movementX
			@trans.dy += event.movementY
	computed:
		transform: ()->
			"translate("+@trans.dx+","+@trans.dy+")"+"scale("+@trans.scale+")"

</script>

<style lang="stylus" scoped>

menubar_height = 30px
statusbar_height = 30px
toolbar_height = 30px
$panel_wrapper_width = 400px
$panel_width = 340px

.wrapper
	position fixed
	left 20px
	right 20px
	top menubar_height
	bottom statusbar_height
	.panel-wrapper
		position absolute
		top 10px
		left 0
		width $panel_width
		.panel
			.panel-header
				height 30px
				width 100%
				text-align center
				vertical-align center
				background-color: #999999
			.panel-body
				border 1px solid #928787
				min-height 60px
	.toolbar
		position absolute
		top 10px
		left $panel_wrapper_width
		right 0px
		border-top 4px solid #999999
		padding 6px 16px 4px 16px
		background-color #CCCCCC
		span
			padding 6px
	.view-wrapper
		position absolute
		top 80px
		left $panel_wrapper_width
		right 0
		bottom 0
		border 1px solid #928787

</style>
