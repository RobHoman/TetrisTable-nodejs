/** IMPORTS **/
/* 3rd Party */
var changeCase = require('change-case')
var glob = require('glob');
var gulp = require('gulp');
var taskListing = require('gulp-task-listing');
var gutil = require('gulp-util');
var clean = require('gulp-clean');
var coffee = require('gulp-coffee');
var mocha = require('gulp-mocha');
var path = require('path');
/* 1st Party */

/** END IMPPORTS **/

var srcGlob = './src/**/*.coffee';
var tstGlob = './tst/**/*.coffee';

var buildDir = './build';
var builtSrcGlob = './build/src/**/*.js';
var builtTstGlob = './build/tst/**/*.js';
var builtTstDirsGlob = './build/tst/**/';

gulp.task('tasks', taskListing);

// Compiles coffeescript
gulp.task('default', ['coffee'], function() {

});

gulp.task('coffee', function() {
	return gulp.src(srcGlob)
		.pipe(coffee({ }).on('error', gutil.log))
		.pipe(gulp.dest('./build/src'));
});

gulp.task('coffee-tst', function() {
	return gulp.src(tstGlob)
		.pipe(coffee({ }).on('error', gutil.log))
		.pipe(gulp.dest('./build/tst'));
});

gulp.task('mocha', ['coffee', 'coffee-tst'], function () {
	gulp.src(builtTstGlob)
		.pipe(mocha({ reporter: 'spec' }));
});

gulp.task('clean', function() {
	return gulp.src(buildDir, { read: false })
		.pipe(clean());
});

glob.sync(builtTstGlob).forEach(function(filePath) {
	createMochaTask(filePath);
});

glob.sync(builtTstDirsGlob).forEach(function(filePath) {
	createMochaTask(filePath);
});

function createMochaTask(filePath) {
	var basename = path.basename(filePath, path.extname(filePath));
	var taskSuffix = changeCase.paramCase(basename);
	var mochaSrcGlob = filePath;
	if (builtTstGlob.substr(-1) === '/') {
		// it ends in '/', so it is a filepath and it needs to be glob-ified
		builtTstGlob += '/**/*.js';
	}
	// TODO When I have logging, add a DEBUG level log here that declares
	// the creation of this task.

	
	gulp.task('mocha-' + taskSuffix, function() {
		return gulp.src(builtTstGlob)
			.pipe(mocha({ reporter: 'spec'}));
	});
}
