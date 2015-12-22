
<template>
<div class="container">
<div class="panel-group">
	<div class="panel panel-primary">
		<div class="panel-heading"></div>
		<div class="panel-body">
			<div class="input-group">
				<div class="input-group-btn">
					<span class="btn btn-default btn-file">Choose File<input type="file" @change="fileChange"/></span>
				</div>
				<input type="text" v-model="localFilePath" class="myinput" readonly/>
				<span class="btn btn-primary pull-right">Add</span>
			</div>
			<div class="input-group">
				<div class="row">
					<div class="col-md-6">
					<div class="form-group">
						<label>Dataset Name</label><input type="text" class="form-control"/>
					</div>
					</div>
					<div class="col-md-6">
					<div class="form-group">
						<label>Dataset Description</label><input type="text" class="form-control"/>
					</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="panel panel-primary">
		<div class="panel-heading"></div>
		<div class="panel-body">
			<h4>CURRENT DATASET : {{curDataset.name || ''}}</h4>
			<table class="table table-striped">
				<thead>
					<tr>
						<th>DatasetName</th>
						<th>DatasetDescription</th>
					</tr>
				</thead>
				<tbody>
					<tr v-for="dataset in datasets" track-by="$index" :class="{'info':curDataset.key==dataset.key}">
						<td @click="changeDataSet(dataset)" class="">{{dataset.name}}</td>
						<td class="">{{dataset.description}}</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<div class="panel panel-primary">
		<div class="panel-body">
			<data-table v-if="curDataset.type == 'csv'" :cur-dataset="curDataset"></data-table>
		</div>
	</div>
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
		localFilePath: ""
		datasets: []
		curDataset:{}
	methods:
		fileChange: (evt)->
			if evt.target.files.length
				@localFilePath = evt.target.files[0].name
			return
		changeDataSet: (dataset)->
			@$set "curDataset",dataset
</script>

<style lang="stylus" scoped>

.btn-file 
	position relative
	overflow hidden
	input[type=file]
		position absolute
		top 0
		right 0
		min-width 100%
		min-height 100%
		font-size 100px
		text-align right
		opacity 0
		outline none
		background white
		cursor inherit
		display block

.myinput
	padding-left 10px
	width 571px
	height 34px
	margin-right 40px

</style>

