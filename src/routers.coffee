'use strict'

module.exports = (router)->
  router.map
    "/":
      name:"home"
      component: require "./views/loaddata.vue"
    "/load":
      name:"home"
      component: require "./views/loaddata.vue"
    "edit":
      name:"edit"
      component: require "./views/edit.vue"
    "/vis":
      name:"vis"
      component: require "./views/vis.vue"
		"/test":
			name: "test"
			component: require "./test/test.vue"
