const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');
const { config } = require('process');

const templateDir = path.join(__dirname, 'php_backup');

function configPage(page, chunks) {
    return new HtmlWebpackPlugin({
        template: path.resolve(templateDir, page + '.php'),
        filename: path.resolve(__dirname, page + '.php'),
        scriptLoading: 'defer',
        minify: false,
        chunks
    })
}

const pages = [
    'account',
    'colours',
    'database',
    'face_shape_links',
    'face_shapes',
    'hair_length_links',
    'hair_lengths',
    'hair_style_links',
    'hair_styles',
    'index',
    'sign_in',
    'sign_up',
    'skin_tone_links',
    'skin_tones',
    'template',
    'user_features',
    'users'
];

const baseChunks = ['index', 'alert', 'authenticate', 'sidebar'];

const mappedPages = () => {
    return pages.map(page => {
        switch(page) {
            case 'account':
            case 'colours':
            case 'database':
            case 'face_shape_links':
            case 'face_shapes':
            case 'hair_length_links':
            case 'hair_lengths':
            case 'hair_style_links':
            case 'hair_styles':
            case 'skin_tone_links':
            case 'skin_tones':
            case 'user_features':
            case 'users':
                return configPage(page, [...baseChunks, page]);
            
            case 'index':
                return configPage(page, [page]);
            
            case 'sign_in':
            case 'sign_up':
                return configPage(page, ['index', 'alert', page]);

            default:
                return configPage(page, baseChunks);
        }
    });
}

module.exports = {
    entry: {
        account: './js/account.js',
        alert: './js/alert.js',
        authenticate: './js/authenticate.js',
        autocomplete: './js/autocomplete.js',
        colours: './js/colours.js',
        database: './js/database.js',
        face_shape_links: './js/face_shape_links.js',
        face_shapes: './js/face_shapes.js',
        hair_length_links: './js/hair_length_links.js',
        hair_lengths: './js/hair_lengths.js',
        hair_style_links: './js/hair_style_links.js',
        hair_styles: './js/hair_styles.js',
        index: './js/index.js',
        redirect: './js/redirect.js',
        search: './js/search.js',
        sidebar: './js/sidebar.js',
        'sign_in': './js/sign_in.js',
        'sign_up': './js/sign_up.js',
        'skin_tone_links': './js/skin_tone_links.js',
        skin_tones: './js/skin_tones.js',
        user_features: './js/user_features.js',
        users: './js/users.js'
    },
    output: {
        path: path.resolve(__dirname, 'dist', 'js'),
        publicPath: 'dist/js/',
        filename: '[name].[contenthash].js'
    },
    resolve: {
        extensions: ['.js', '.jsx', '.json', '.ts', '.tsx']
    },
    plugins: [
        new CleanWebpackPlugin(),
        ...mappedPages()
    ]
}