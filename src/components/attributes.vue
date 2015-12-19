<template>

<div class="sd-frame">
	<div class="sd-frame-header">{{title}}</div>
</div>

</template>

<script>

module.export=
	props:
		title:
			type:String

</script>

<style lang="less" scoped>

.sd-frame{
	width: 300px;
	.sd-frame-header{
		height: 20px;
		background: green;
		border: 1px solid black;
	}	
}

</style>
