var gulp = require('gulp');
var gutil = require('gulp-util');
var clean = require('gulp-clean');
var coffee = require('gulp-coffee');
var mocha = require('gulp-mocha');

// Compiles coffeescript
gulp.task('default', ['coffee'], function() {

});

gulp.task('coffee', function() {
	return gulp.src('./src/**/*.coffee')
		.pipe(coffee({ }).on('error', gutil.log))
		.pipe(gulp.dest('./build/src'));
});

gulp.task('coffee-tst', function() {
	return gulp.src('./tst/**/*.coffee')
		.pipe(coffee({ }).on('error', gutil.log))
		.pipe(gulp.dest('./build/tst'));
});

gulp.task('mocha', ['coffee', 'coffee-tst'], function () {
	gulp.src('./build/tst/**/*.js')
		.pipe(mocha({ reporter: 'spec' }));
});


gulp.task('clean', function() {
	return gulp.src('./build', { read: false })
		.pipe(clean());
});
