# Build a project using devenv.com
### Overview
This extension will add a build task in your TFS/VSTS instance that will allow you to build your projects using DevEnv.com (Visual Studio). Most of the .Net projects are built by MsBuild and there are out of the box tasks that will allow you to do so. However, some project types, as Integration Services Project can only be built with Visual Studio as they are not based on MSBuild.

### Requirements
The desired Visual Studio version needs to be present on your build server.


### The different parameters of the task are explained below:

* **Project**: Solution or project that you intend to build.
* **Configuration**: Build configuration. Eg. 'Release'
* **Platform**: Build platform; only applied when a build configuration is specified. Leave blank for solution/project default.
* **Visual Studio Version"**: A specific version of Visual Studio that should be used for this build (in case of multiple versions present on the build server).
* **Deploy**: Builds the solution, along with files necessary for deployment, according to the solutions configuration. The specified project must be a deployment project. If the specified project is not a deployment project, when the project that has been built is passed to be deployed, it fails with an error.
* **Clean**: Deletes any files created by the build command, without affecting source files.

## Contributing

Feel free to notify any issue in the issues section of this GitHub repository. In order to build this task, you will need Node.js and gulp installed. Once cloned the repository, just run 'npm install' then 'gulp package' and in the newly created folder called _packages you will find a new version of the extension.