const { merge } = require('webpack-merge');
const common = require('./webpack.common.js');
const WebpackManifestPlugin = require('webpack-manifest-plugin');

module.exports = merge(common, {
    mode: 'production',
    module: {
        rules: [
            {
                test: /\.m?js$/,
                exclude: /(node_modules|bower_components)/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: ['@babel/preset-env'],
                        plugins: ['@babel/plugin-transform-runtime', '@babel/plugin-transform-regenerator']
                    }
                }
            }
        ]
    },
    plugins: [
        new WebpackManifestPlugin()
    ]
});