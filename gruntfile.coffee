module.exports = (grunt) ->
    "use strict"
    
    grunt.initConfig

        # Metadata
        pkg: grunt.file.readJSON 'package.json'
        copyright: "Copyright <%= grunt.template.today('yyyy') %>"
        banner: """@*!
                    * <%= pkg.title %> v<%= pkg.version %> (<%= pkg.homepage %>)
                    * <%= copyright %> <%= pkg.author.name %>
                    * Licensed under <%= _.pluck(pkg.licenses, 'url').join(', ') %>
                    *@

                """

        # Task configuration
        clean: 
            build: ['build/']
            dist: ['dist/']        
        copy: 
            dist:
                expand: true
                cwd: '<%= copy.src.dest %>/'
                src: 'GlyphIcon.cshtml'
                dest: 'dist/'
            src:
                expand: true
                cwd: 'src/'
                src: ['GlyphIcon.cshtml']
                dest: 'build/Content/App_Code/'
        nugetpack:
            dist:
                src: 'build/Package.nuspec'
                dest: 'dist/'
        nugetpush:
            dist:
                src: 'dist/*.nupkg'
        template:
            nuspec:
                options:
                    data:
                        author: '<%= pkg.author.name %>'
                        copyright: '<%= copyright %>'
                        description: '<%= pkg.description %>'
                        icon: 'http://kodefuguru.com/glyphicon/logo'
                        id: '<%= pkg.name %>'
                        language: 'en-US'
                        licenseUrl: "<%= _.pluck(pkg.licenses, 'url')[0] %>"
                        projectUrl: '<%= pkg.homepage %>'
                        requireLicenseAcceptance: 'false'
                        tags: "<%= pkg.keywords.join(' ') %>"
                        version: '<%= pkg.version %>'
                src: 'src/Package.nuspec.tpl'
                dest: 'build/Package.nuspec'
                    
        watch: 
            src: 
                files: '<%= copy.src.src %>'
                tasks: ['build']
        usebanner:
            build:
                options:
                    banner: '<%= banner %>'
                files: 
                    src: [ '<%= copy.src.dest %>/GlyphIcon.cshtml' ]
                

    grunt.loadNpmTasks 'grunt-banner'    
    grunt.loadNpmTasks 'grunt-nuget'
    grunt.loadNpmTasks 'grunt-template'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-watch'

    grunt.registerTask 'test', []
    grunt.registerTask 'build', ['clean:build', 'copy:src', 'usebanner', 'template']
    grunt.registerTask 'dist', ['clean:dist', 'nugetpack', 'copy:dist']
    grunt.registerTask 'default', ['build', 'test', 'dist']
 