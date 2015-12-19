<template>

<select value="{{val}}" @change="change">{{lst[val].name}}
	<option v-for="o in lst" value="{{$index}}">{{o.name}}</option>
</select>

</template>

<script lang="coffee">

module.exports=
	methods:
		change:(event)->
			# @val = event.target.value
			@$dispatch "item_change",@idx,event.target.value
	props:
		lst: Array
		val: Number
		idx: Number
	data: ()->{}
		
</script>

<style>

</style>
