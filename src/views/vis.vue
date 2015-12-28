<template>
<div class="wrapper">
	<div class="toolbar">
		<toolbar :trans="trans"></toolbar>
	</div>
	<div class="panel-wrapper">
		<div class="panel panel-primary">
			<div class="panel-heading">Control Panel</div>
			<div class="panel-body">
				<control-panel></control-panel>
			</div>
		</div>
		<div class="panel panel-primary">
			<div class="panel-heading">View Control Panel</div>
			<div class="panel-body">
				<component :is="curViewControl"></component>
			</div>
		</div>
		<div class="panel panel-primary">
			<div class="panel-heading">Attribute Panel</div>
			<div class="panel-body">
				<attribute-panel></attribute-panel>
			</div>
		</div>
	</div>
	<div class="view-wrapper" v-el:svg-wrapper>
		<svg width="100%" height="100%">
			<g class="view" :transform="transform">
				<component :is="curView"></component>
			</g>
		</svg>
	</div>
</div>

</template>

<script lang="coffee">

d3 = require "d3"
$ = require "jquery"
_ = require "underscore"

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

Tree = require("../utils/Tree.coffee").Tree
prefix= require("../utils/Tree.coffee").prefix

_evt_broadcast = (evt,fn)->
	(args)->
		if typeof fn is 'function'
			fn args
		if typeof @["on_"+evt] is 'function'
			@["on_"+evt] args
		@$broadcast evt,args

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
		trans: controlStore.pos
		fix: controlStore.fix
		curView: "tree"+"View"
		curViewControl: "tree"+"Control"
		data: 0
		root: {}
	asyncData: (resove,reject)->
		dataKey = "flare"
		that = @
		@$http.get "datasets/"+dataKey,(data)->
			that.data = data
			if data.type is "json"
				d3.json data.path, (d)->
					data.data = d
					that.$broadcast "event_control_change_root",d
					that.$broadcast "event_load_data",data
			else if data.type is "csv"
				d3.csv data.path, (d)->
					data.data = d
					that.$broadcast "event_load_data",data
			else
				return
		return
	events:
		event_fix_position: (dx,dy)->
			@fix.dx = dx
			@fix.dy = dy
		event_toolbar_set_drag: (dragSet)->
			@$broadcast "event_drag_set",dragSet
			@onSetDrag(dragSet)
		event_toolbar_reset_position: ()->
			@trans.scale = 0.8
			@trans.dx = 20
			@trans.dy = 20
		event_select_node: _evt_broadcast "event_select_node"
		#
		event_control_change_view: (viewName)->
			@onChangeView(viewName)
		event_control_change_size_by: _evt_broadcast "event_control_change_size_by"
		event_control_change_color_by: _evt_broadcast "event_control_change_color_by"
		event_control_change_sellst: (sels)->
			if !@data or @data.type == 'json'
				return
			tree = new Tree @data.data
			tree.treefy sels
			tree.tranverse d3.sum,()->1
			@$broadcast "event_control_change_root",tree.root
		event_tree_change_layout: _evt_broadcast "event_tree_change_layout"
		event_tree_change_radius_scale: _evt_broadcast "event_tree_change_radius_scale"
		#
		event_control_treemap_change_layout: _evt_broadcast "event_control_treemap_change_layout"
		event_control_treemap_change_paddings: _evt_broadcast "event_control_treemap_change_paddings"
		event_control_treemap_change_round: _evt_broadcast "event_control_treemap_change_round"
		event_control_treemap_change_sticky: _evt_broadcast "event_control_treemap_change_sticky"
	methods:
		onChangeView: (viewName)->
			@fix.dx = 0
			@fix.dy = 0
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
			dx = @trans.dx + @fix.dx
			dy = @trans.dy + @fix.dy
			"translate("+dx+","+dy+")"+"scale("+@trans.scale+")"

</script>

<style lang="stylus">

.panel-heading
	padding 0px 10px
.panel-body
	padding 10px

.btn
	padding 5px 10px
	font-size 12px
	line-height 1.2
	border-radius 3px

</style>

<style lang="stylus" scoped>

menubar_height = 50px
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
