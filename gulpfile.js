const gulp = require('gulp');
const rename = require('gulp-rename');
const sass = require('gulp-sass');
const cssmin = require('gulp-cssmin');
const uglify = require('gulp-uglify');
const rollup = require('rollup');
const coffee = require('rollup-plugin-coffee-script');
const nodeResolve = require('rollup-plugin-node-resolve');
const commonjs = require('rollup-plugin-commonjs');
const babel = require('rollup-plugin-babel');
const pkg = require('./package');

gulp.task('scss', async () => {
    await new Promise(resolve => {
        gulp.src('./src/scss/marvina-carousel.scss')
        .pipe(sass())
        .on('error', e => {
            console.log(e);
            resolve();
        })
        .pipe(gulp.dest('./dist/css'))
        .on('error', resolve)
        .on('end', resolve);
    });

    await new Promise(resolve => {
        gulp.src('./dist/css/marvina-carousel.css')
        .pipe(cssmin())
        .pipe(rename('marvina-carousel.min.css'))
        .pipe(gulp.dest('./dist/css'))
        .on('end', resolve);
    });
});

const banner = `/*!
 *   Marvina carousel
 *   version: ${pkg.version}
 *    author: ${pkg.author.name} <${pkg.author.email}>
 *   website: ${pkg.author.url}
 *    github: ${pkg.repository.url}
 *   license: ${pkg.license}
 */ 
`;
gulp.task('script', async () => {
    const bundle = await rollup.rollup({
        input: './src/script/index.coffee',
        plugins: [
            coffee({
                exclude: /node_modules/
            }),
            nodeResolve({
                extensions: ['.js', '.coffee'] 
            }),
            commonjs({
                extensions: ['.js', '.coffee']
            }),
            babel({
                plugins: [
                    ['external-helpers'],
                    ['transform-runtime', {
                        'helpers': false,
                        'polyfill': false,
                        'regenerator': true,
                        'moduleName': 'babel-runtime'
                    }]
                ],
                presets: [
                    ['env', {modules: false}], ['stage-3']
                ]
            })
        ]
    });

    await bundle.write({
        banner,
        file: 'dist/js/marvina-carousel.js',
        format: 'umd',
        name: 'MarvinaCarousel'
    });

    await bundle.write({
        banner,
        file: 'dist/js/marvina-carousel.common.js',
        format: 'cjs'
    });

    await bundle.write({
        banner,
        file: 'dist/js/marvina-carousel.esm.js',
        format: 'es',
    });

    gulp.src('dist/js/marvina-carousel.js')
    .pipe(uglify({
        output: {
            comments: /marvina-carousel/
        }
    }))
    .pipe(rename('marvina-carousel.min.js'))
    .pipe(gulp.dest('./dist/js'));
});

gulp.task('default', () => {
    gulp.watch('./src/scss/**', ['scss']);
    gulp.watch('./src/script/**', ['script']);
    gulp.start(['scss', 'script']);
});