<template>
<div>
		<span :class="{'btn-primary-outline':!dragSet, 'btn-primary':dragSet}" @click="dragSet=!dragSet"><i class="fa fa-arrows"></i></span>
		<span>Scale: {{Math.floor(trans.scale*100)}} %</span>
		<span @click="resetPosition"><i class="fa fa-refresh"></i></span>
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

</style>
