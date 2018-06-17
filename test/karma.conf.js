const webpackConfig = require('./webpack.config.js');
webpackConfig.entry = '';

module.exports = config => {
    config.set({
        autoWatch: false,
        basePath: '',
        browsers: ['ChromeHeadlessWithoutSandbox'],
        customLaunchers: {
          ChromeHeadlessWithoutSandbox: {
            base: 'ChromeHeadless',
            flags: ['--no-sandbox'],
          },
        },
        files: [
            '../dist/js/marvina-carousel.js',
            'spec/*.test.coffee'
        ],
        preprocessors: {
            'spec/*.test.coffee': ['webpack']
        },
        frameworks: ['jasmine'],
        reporters: ['spec'],
        singleRun: true,
        webpack: webpackConfig,
        webpackMiddleware: {
            noInfo: true
        }
    });
};