<template>

<div>
	<div class="group">
		<div class="name">Radial</div>
		<div class="vals">
			<input type="checkbox" v-model="control.radial"/>
		</div>
	</div>
	<div class="group">
		<div class="name">Labels</div>
		<div class="vals">
			<input type="checkbox" v-model="control.labels"/>
		</div>
	</div>
</div>

</template>

<script lang="coffee">

## used by viewSpecific

control = require("../../utils/ControlStore.coffee").icicle

module.exports=
	data: () ->
		control: control
	methods: {}

</script>

<style lang="stylus" scoped>

</style>
