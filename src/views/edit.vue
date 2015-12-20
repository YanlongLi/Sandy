
<template>

<div class="container base">
	<div class="row">
		<div class="container row">
			<div class="col-md-4"><label>Data File</label></div>
			<div class="col-md-6"><input type="file" /> </div>
			<div class="col-md-2"><button class="btn btn-primary">Submit</button></div>
		</div>
	</div>
	<div class="row">
		<p>current dataset : {{curDataSet}}</p>
		<div v-for="dataset in datasets" track-by="$index" class="container">
			<div @click="changeDataSet(dataset.name)" class="col-md-6 dataname">{{dataset.name}}</div>
			<div class="col-md-6 datadesc">{{dataset.description}}</div>
		</div>
	</div>
	<div class="row">
		<data-table></data-table>
	</div>
</div>

</template>

<script lang="coffee">

dataTable = require "../components/Edit/DataTable.vue"

module.exports=
	components:
		dataTable: dataTable
	asyncData: (resolve, reject)->
		@$http.get "/datasets/",(data,status)->
			resolve datasets:data
		return
	data: ()->
		datasets: []
		curDataSet:""
	methods:
		changeDataSet: (dataset)->
			@curDataSet = dataset
			resource = @$resource "/datasets/:name"
			resource.get {name:dataset},(data,status)->
				console.log dataset,data
</script>

<style lang="stylus" scoped>

.base
	margin-top 30px
	line-height 30px
	padding 20px
	border 1px solid #CCCCCC

dataname
	font-weight bold

datadesc
	font-style italic

</style>

