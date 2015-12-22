
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
      {test: /\.stylus/, loader:'css!stylus'},
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
