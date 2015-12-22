<template>
<div>
		<span :class="{'btn-primary-outline':!dragSet, 'btn-primary':dragSet}" @click="dragSet=!dragSet"><i class="fa fa-arrows"></i></span>
		<span>Scale: {{Math.floor(trans.scale*100)}} %</span>
		<span @click="resetPosition"><i class="fa fa-refresh"></i></span>
		<div class="form-group searchfield">
			<input type="text" class="form-control" placeholder="Search">
		</div>
<div>
</template>

<script lang="coffee">

module.exports=
	props:
		trans: Object
	data: () ->
		dragSet: false
	watch:
		dragSet: (dragSet) ->
			@$dispatch "event_toolbar_set_drag",dragSet
	methods:
		resetPosition: ()->
			@$dispatch "event_toolbar_reset_position"

</script>

<style lang="stylus">

.searchfield
	float right
	margin 0
	input
		line-height 30px
		height 30px
		padding-top 0
		padding-bottom 0

</style>
