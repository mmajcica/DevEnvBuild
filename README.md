# Build a project using devenv.com

## Overview

This extension will add a build task in your TFS/VSTS instance that will allow you to build your projects using DevEnv.com (Visual Studio). Most of the .Net projects are built by MSBuild and there are out of the box tasks that will allow you to do so. However, some project types, as Integration Services Project can only be built with Visual Studio as they are not based on MSBuild.

You can read more about this extension in the post [Building Visual Studio projects with DevEnv.com](http://blog.majcica.com/2019/05/30/building-visual-studio-projects-with-devenv-com/) and get some insights in practical usage of it in the post [Deploy SSIS packages from TFS/VSTS Build/Release](http://blog.majcica.com/2018/04/25/deploy-ssis-packages-from-tfs-vsts-build-release/).

## Requirements

The desired Visual Studio version needs to be present on your build server.

### The different parameters of the task are explained below

* **Solution / Project**: Solution or Project to build. When you enter a project file, the IDE looks for an .sln file with the same base name as the project file in the parent directory for the project file. If no such .sln file exists, then the IDE looks for a single .sln file that references the project. If no such single .sln file exists, then the IDE creates an unsaved solution with a default .sln file name that has the same base name as the project file.
* **Project**: Specifies the project to build, clean, or deploy.
* **Configuration**: Build configuration. Eg. 'Release'
* **Platform**: Build platform; only applied when a build configuration is specified. Leave blank for solution/project default.
* **Visual Studio Version"**: A specific version of Visual Studio that should be used for this build (in case of multiple versions present on the build server).
* **Deploy**: Builds the solution, along with files necessary for deployment, according to the solutions configuration. The specified project must be a deployment project. If the specified project is not a deployment project, when the project that has been built is passed to be deployed, it fails with an error.
* **Clean**: Deletes any files created by the build command, without affecting source files.

## Release notes

* 2.0.3 - Updated Task Library to v0.11.0. Updated VSSetup library to v2.2.5. Added the support for VS2019. Added extra Project filed/parameter. Solution parameter now supports wildcards [#1](https://github.com/mmajcica/DevEnvBuild/issues/1).
* 1.0.2 - Minor improvements on the extension. No task changes
* 1.0.1 - Initial Release

## Contributing

Feel free to notify any issue in the issues section of this GitHub repository. In order to build this task, you will need Node.js and gulp installed. Once cloned the repository, just run 'npm install' then 'gulp package' and in the newly created folder called _packages you will find a new version of the extension.