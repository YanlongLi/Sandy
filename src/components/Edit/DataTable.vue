<template>

<table class="table table-striped">
	<thead><tr>
	<th>ID</th>
	<th v-for="key in keyLst" contenteditable> {{key}}({{typeLst[$index]}}) </th>
	</tr></thead>
	<tbody>
		<tr v-for="row in data">
			<td>{{$index}}</td>
			<td contenteditable v-for="key in keyLst">{{row[key]}}</td>
		</tr>
	</tbody>
</table>

</template>

<script lang="coffee">

dataStore = require "../../utils/DataStore.coffee"

module.exports=
	props:
		curDataset: Object
	data: ()->
		data: []
		keyLst: []
		typeLst: []
	asyncData: (resolve, reject)->
		schema = @curDataset.schema
		@keyLst = (attr for attr in schema.name)
		@typeLst = (attr for attr in schema.type)
		d3.csv @curDataset.path,(err,data)->
			resolve data:data
		return
</script>

<style lang="stylus">

</style>
