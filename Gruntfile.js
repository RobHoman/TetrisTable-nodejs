module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    
    pkg: grunt.file.readJSON('package.json'),
    
    uglify: {
      options: {
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
      },
      files: {
        expand: true,
        cwd: 'build/coffee/',
        src: ['**/*.js'],
        dest: 'build/uglify/',
        ext: '.min.js',
        extDoc: 'first'
      }
    },
    coffee: {
      glob_to_multiple: {
        expand: true,
        flatten: true,
        cwd: 'src/',
        src: ['**/*.coffee'],
        dest: 'build/coffee/',
        ext: '.js'
      }
    }
  });

  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-contrib-uglify');

  // Load the plugin that provides the "coffee" task.
  grunt.loadNpmTasks('grunt-contrib-coffee');

  // Default task(s).
  grunt.registerTask('default', ['coffee']);

};
