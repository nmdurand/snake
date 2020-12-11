HtmlWebpackPlugin = require 'html-webpack-plugin'
path = require 'path'

module.exports =
	mode: 'development'
	devServer:
		contentBase: path.join __dirname,'dist'
	context: path.join __dirname,'src'
	entry: './main.coffee'
	output:
		filename: 'main.js'
		path: path.resolve __dirname, 'dist'
	module:
		rules: [
			test: /\.coffee$/,
			loader: 'coffee-loader'
		]
	plugins: [
		new HtmlWebpackPlugin
			template: './index.html'
	]
	resolve:
		extensions: ['.js','.coffee']
		modules: ['node_modules']
