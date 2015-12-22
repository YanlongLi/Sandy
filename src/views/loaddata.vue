<template>

<modal title="Load Data" :show.sync="isUpload" effect="fade" :width="800">
  <div class="modal-body">
		asklfjaskdlfajskdlf
		<div class="input-group">
			<span class="input-group-addon">DataSet Name</span>
			<input type="text" class="form-control" placeholder="DataSet Name" aria-describedby="basic-addon2" v-bind="dataName">
			<span class="input-group-addon">DataSet Description</span>
			<input type="text" class="form-control" placeholder="DataSet Description" aria-describedby="basic-addon2" v-bind="dataDesc">
			<span class="input-group-addon">Data</span>
			<input type="file" class="form-control" placeholder="DataSet Description" aria-describedby="basic-addon2" v-bind="dataDesc">
		</div>
	</div>
</modal>

</template>

<script lang="coffee">

modal = require("vue-strap").modal

module.exports =
	components:
		modal: modal
	data: ()->
		return {
			dataName:"",
			isUpload: false
		}
	methods:
		upload:()->
			return

</script>

<style>

</style>
