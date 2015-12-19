
Vue = require "vue"
VueRouter = require 'vue-router'
VueResource = require('vue-resource')
VueAsyncData = require('vue-async-data')

Vue.use VueRouter
Vue.use VueResource
Vue.use VueAsyncData

Vue.config.debug = true

router = new VueRouter
  hashbang: true
  history: false
  transitionOnLoad: true

app = Vue.extend {}

require("./routers.coffee")(router)

router.start(app, "#app")
