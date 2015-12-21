<template>
<div class="wrapper">
	<div class="toolbar">
		<toolbar :trans="trans"></toolbar>
	</div>
	<div class="panel-wrapper">
		<div class="panel">
			<div class="panel-header">Control Panel</div>
			<div class="panel-body">
				<control-panel></control-panel>
			</div>
		</div>
		<div class="panel">
			<div class="panel-header">Attribute Panel</div>
			<div class="panel-body">
				<attribute-panel></attribute-panel>
			</div>
		</div>
	</div>
	<div class="view-wrapper" v-el:svg-wrapper>
		<svg width="100%" height="100%">
			<g class="view" :transform="transform">
				<component :is="curView" keep-alive ></component>
			</g>
		</svg>
	</div>
</div>

</template>

<script lang="coffee">

d3 = require "d3"
$ = require "jquery"

treeview = require "../components/TreeView/TreeView.vue"
treemapview = require "../components/TreemapView/TreemapView.vue"
icicleview = require "../components/IcicleView/IcicleView.vue"
indentview = require "../components/IndentView/IndentView.vue"

control = require "../components/Control/ControlPanel.vue"
attribute = require "../components/Attribute/AttributePanel.vue"
toolbar = require "../components/toolbar.vue"

module.exports=
	components:
		treeView: treeview
		treemapView: treemapview
		icicleView: icicleview
		indentView: indentview
		controlPanel: control
		attributePanel: attribute
		toolbar: toolbar
	data: ()->
		trans:
			dx:20
			dy:20
			scale:0.8
		curView: "treeView"
	events:
		event_set_drag: (dragSet)->
			@$broadcast "event_drag_set",dragSet
			@onSetDrag(dragSet)
		event_reset_position: ()->
			@trans.scale = 0.8
			@trans.dx = 20
			@trans.dy = 20
		event_select_node: (node)->
			@$broadcast "event_select_node",node
		event_change_view: (viewName)->
			@onChangeView(viewName)
	methods:
		onChangeView: (viewName)->
			@curView = viewName
		onSetDrag: ()->
			false
	ready: ()->
		isMouseDown = false
		trans = @trans
		divMouseWheel= (event)->
			getD = (dx,os,ns,xoff)-> (xoff*(os-ns)+dx*ns)/os
			oS = trans.scale
			nS = oS + (event.originalEvent.wheelDelta / 1200.0)
			trans.dx = getD trans.dx,oS,nS,event.originalEvent.offsetX
			trans.dy = getD trans.dy,oS,nS,event.originalEvent.offsetY
			trans.scale = nS
		divMouseDown= ()->
			isMouseDown = true
		divMouseUp= ()->
			isMouseDown = false
		divMouseMove= (event)->
			return if !isMouseDown
			trans.dx += event.originalEvent.movementX
			trans.dy += event.originalEvent.movementY
		el = @$els.svgWrapper
		@onSetDrag = (dragSet) ->
			if dragSet
				$(el).on "mousedown",divMouseDown
				$(el).on "mouseup",divMouseUp
				$(el).on "mousemove",divMouseMove
				$(el).on "mousewheel",divMouseWheel
			else
				$(el).off "mousedown",divMouseDown
				$(el).off "mouseup",divMouseUp
				$(el).off "mousemove",divMouseMove
				$(el).off "mousewheel",divMouseWheel
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
