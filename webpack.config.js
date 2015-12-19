
module.exports = {
  entry: "./src/main.coffee",
  output: {
    path: "./dist",
    filename: "build.js"
  },
  module: {
    loaders:[
      {test: /\.vue$/, loader:'vue'},
      {test: /\.coffee$/, loader:'coffee'},
      {test: /\.json$/, loader:'json'},
    ]
  }
  /*
   * vue: {
   *   loaders:{
   *     js: 'coffee'
   *   }
   * }
   */
}
