<template>

<div>
	Name: {{curNode.name}}
	<br>
	Depth: {{curNode.depth}}
</div>

</template>

<script lang="coffee">

module.exports=
	props:
		curNode: Object
	data: ()->{}


</script>

<style lang="stylus">

</style>
