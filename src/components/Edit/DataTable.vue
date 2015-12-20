<template>

<table></table>

</template>

<script lang="coffee">

dataStore = require "../../utils/DataStore.coffee"

module.exports=
	data: ()->
		curDataSet: dataStore || "dataset name"

</script>

<style lang="stylus">

</style>
