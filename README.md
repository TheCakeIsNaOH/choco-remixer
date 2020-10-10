## What is this?

This automates [internalizing/recompiling](https://chocolatey.org/docs/how-to-recompile-packages) select Chocolatey packages.

## Why? 

- Because relying on software to be available at a specific URL on the internet in perpetuity is not a good idea.
- Manually downloading and internalizing for each package version is a lot of work.
- The [Chocolatey business license](https://chocolatey.org/pricing#faq-pricing) that also has [automated internalization functionality](https://chocolatey.org/docs/features-automatically-recompile-packages) is:
 
   - Not open source
   - Too expensive for almost all non-business users because it starts at $1,600/year
   - May require an ongoing license to continue to use the packages that are internalized with the business extension. 

## Requirements

- PowerShell v5.1+ - Used so far only on windows, should be compatible with Linux without too much effort
- `choco` installed and on your path
- A nuget repository or a folder with `.nupkg`s to internalize. Nexus is the repository that I use and test with.
	- Drop path's are available with ProGet only
	- RepoMove and RepoSearch are Nexus only

## Setup 

- Clone this repository
- Chocolatey is required, make sure that it is installed and working properly. 
- Copy `personal-packages.xml.template` to `personal-packages.xml` and edit it. 
    - See the file for comments about each of the options.
    - It is searched for first under `%appdata%`/`.config` in the choco-remixer folder, then it looks in the same folder that choco-remixer runs from. You can also provide a path to it.
- If you are using the automatic pushing (`pushPkgs`), make sure `choco` has the appropriate `apikey` setup for that URL.
- It is a good idea to put `personal-packages.xml` in a git repository.

## Operation 

- Run `Internalize-ChocoPkg.ps1` in PowerShell

- If you have `useDropPath` and `pushPkgs` disabled, the internalized packages are located inside the specified `workDir`.
- If you have `writePerPkgs` disabled, add the package versions to `personal-packages.xml` under the correct IDs. Otherwise, it will try to internalize them again.

- If there are errors, run with the 

## Caveats

- I am still actively developing this, I make no promises that it is %100 stable.
- Packages are supported by whitelist, and support must be added individually for each package. Only a limited subset of packages on chocolatey.org that are not internal are supported at this moment.
- Error checking is not ideal yet, and there is no logging

## Todo

- Search in subdir of work dir as well, if readonly search dir or something
- Input creds during run.
- output current/old package version during repoCheck

- move more packages to no custom function, all declared in xml
	
- change functions to use all passed things, not script variables, and strings and whatnot
- Checksum downloads
- Logging, and support verbose well
- Error checking and handling
- Turn into proper module
- Make individual package functions better
	- generalize more functionality and make available as functions. 
  
    ### Long term
  
  - Async/Parallelize file searching, copying, packing, possibly downloading 
  - Drop dependency on `choco`, possibly requires chocolatey to update the nuget.exe version as current version does not extract files added to zip after pack.
	- Move to `chocolatey.lib` instead?
	- Figure out why does not extract files
	- Alternate push? `chocolatey.lib`? Nexus API, will reduce compatibility? Dotnet?
  - Ability to bump version of nupkg
  - Extract files individually rather then extracting all and removing excess, difficult because of packages like virtualbox that have files in root dir
  - Add option to trust names of nupkg's in searching
  - Git integration for personal-packages.xml
  - Multiple personal-packages.xml files