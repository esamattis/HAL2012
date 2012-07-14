/*global module:false*/
module.exports = function(grunt) {
  grunt.loadNpmTasks('grunt-contrib');
  grunt.loadNpmTasks('grunt-coffee');

  // Project configuration.
  grunt.initConfig({
    meta: {
      version: '0.1.0',
      banner: '/*! halhome - v<%= meta.version %> - ' +
        '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
        '* http://github.com/epeli/halhome/\n' +
        '* Copyright (c) <%= grunt.template.today("yyyy") %> ' +
        'Esa-Matti Suuronen; Licensed MIT */'
    },
    coffee: {
      app: {
        src:  "public/scripts/src/*",
        dest: "public/scripts/app/"
      }
    },
    requirejs: {
      compile: {
        options: {
          baseUrl : "public/scripts",
          paths: {
            jquery: "vendor/jquery",
            moment: "vendor/moment",
            sockjs: "vendor/sockjs"
          },
          name: "app/main",
          out: "public/scripts/app/bundle.js"
        }
      }
    },
    watch: {
      files: "public/scripts/src/*",
      tasks: "coffee"
    }
  });

  // Default task.
  grunt.registerTask("default", "coffee requirejs");

};
