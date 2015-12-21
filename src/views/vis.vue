<template>
<div class="wrapper">
	<div class="toolbar">
		<toolbar :trans="trans"></toolbar>
	</div>
	<div class="panel-wrapper">
		<div class="mypanel">
			<div class="mypanel-header">Control Panel</div>
			<div class="mypanel-body">
				<control-panel></control-panel>
			</div>
		</div>
		<div class="mypanel">
			<div class="mypanel-header">View Control Panel</div>
			<div class="mypanel-body">
				<component :is="curViewControl" keep-alive ></component>
			</div>
		</div>
		<div class="mypanel">
			<div class="mypanel-header">Attribute Panel</div>
			<div class="mypanel-body">
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

treecontrol = require "../components/Control/TreeView.vue"
treemapcontrol = require "../components/Control/TreemapView.vue"
iciclecontrol = require "../components/Control/IcicleView.vue"
indentcontrol = require "../components/Control/IndentView.vue"

control = require "../components/Control/ControlPanel.vue"
attribute = require "../components/Attribute/AttributePanel.vue"
toolbar = require "../components/toolbar.vue"

controlStore = require "../utils/ControlStore.coffee"

module.exports=
	components:
		treeView: treeview
		treemapView: treemapview
		icicleView: icicleview
		indentView: indentview
		controlPanel: control
		treeControl: treecontrol
		treemapControl: treemapcontrol
		icicleControl: iciclecontrol
		indentControl: indentcontrol
		attributePanel: attribute
		toolbar: toolbar
	data: ()->
		trans:
			dx:20
			dy:20
			scale:0.8
		curView: "tree"+"View"
		curViewControl: "tree"+"Control"
	events:
		event_toolbar_set_drag: (dragSet)->
			@$broadcast "event_drag_set",dragSet
			@onSetDrag(dragSet)
		event_toolbar_reset_position: ()->
			@trans.scale = 0.8
			@trans.dx = 20
			@trans.dy = 20
		event_select_node: (node)->
			@$broadcast "event_select_node",node
		event_control_change_view: (viewName)->
			@onChangeView(viewName)
		event_tree_change_layout: (layout)->
			@$broadcast "event_tree_change_layout",layout
			
	methods:
		onChangeView: (viewName)->
			@curView = viewName+"View"
			@curViewControl = viewName+"Control"
		onSetDrag: ()->
			false
	ready: ()->
		el = @$els.svgWrapper
		w = $(el).width()
		h = $(el).height()
		controlStore.setSize({width:w,height:h})
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
		bottom statusbar_height
		left 0
		width $panel_width
		overflow scroll
		.mypanel
			background-color #d9edf7
			border 1px solid #333333
			border-radius 4px
			margin-bottom 20px
			.mypanel-header
				height 30px
				width 100%
				text-align center
				line-height:30px
			.mypanel-body
				min-height 60px
				border 1px solid #666666
				margin 0 4px 4px
				background-color white
				padding 6px 10px
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
