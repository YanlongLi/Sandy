<template>

<div>
<div class="group">
	<span class="name">Max Width</span>
	<span class="input-group vals">
		<input type="text" class="input-control" v-model="control.width"/> 
	</span>
	<div style="clear:both"></div>
</div>
<div class="group">
	<span class="name">Element Height</span>
	<span class="input-group vals">
		<input type="text" class="input-control" v-model="control.height"/> 
	</span>
	<div style="clear:both"></div>
</div>
<div class="group">
	<span class="name">Indent Size</span>
	<span class="input-group vals">
		<input type="text" class="input-control" v-model="control.indent"/> 
	</span>
	<div style="clear:both"></div>
</div>
</div>

</template>

<script lang="coffee">

## used by viewSpecific
control = require("../../utils/ControlStore.coffee").indent

module.exports=
	data: () ->
		control: control
	methods: {}

</script>

<style lang="stylus" src="../../css/cgroup.stylus"></style>

<style lang="stylus">

</style>
