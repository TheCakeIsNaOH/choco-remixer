## What is this?

This automates some tasks involved in maintaining a private Chocolatey repository, specifically focusing on repositories hosted on Nexus.

- Checking for packages that out of date in a Nexus nuget repository, and updating them.

- Moving packages from a Nexus proxy repository to a hosted Nexus repository.

- [Internalizing/Recompiling](https://chocolatey.org/docs/how-to-recompile-packages) select Chocolatey packages, otherwise known as embedding the binaries inside the package.

## Requirements

- PowerShell v5.1+ - Primarily used so far on Windows, should work fine with Linux, but I have not thoroughly tested it yet.
- `choco` installed and on your path
- A nuget repository or a folder with `.nupkg`s to internalize. Nexus is the repository that I use and test with.
	- Drop path's are available with ProGet only
	- RepoMove and RepoSearch are Nexus only

## Setup

- Clone this repository
- Chocolatey is required, make sure that it is installed and working properly.
- Copy `*.xml.template` files to `*.xml` and edit them.
    - See the files for comments about each of the options.
    - It is searched for first under `%appdata%`/`.config` in the choco-remixer folder, then it looks in the same folder that choco-remixer runs from. You can also provide a path to it.
- If you are using the automatic pushing (`pushPkgs`), make sure `choco` has the appropriate `apikey` setup for that URL.
- It is a good idea to put the xml files in a git repository.

## Operation

- Import the `choco-remixer` PowerShell module 
- Run `Invoke-InternalizeChocoPkg`

- If you have `useDropPath` and `pushPkgs` disabled, the internalized packages are located inside the specified `workDir`.
- If you have `writePerPkgs` disabled, add the package versions to `internalized.xml` under the correct IDs. Otherwise, it will try to internalize them again.

- If continuously re-running for development or bug fixing, use the `-skipRepoCheck` switch, so as to not get rate limited by chocolatey.org

## Adding support for more packages

See [ADDING_PACKAGES.md (in progress)](https://github.com/TheCakeIsNaOH/choco-remixer/blob/master/ADDING_PACKAGES.md) for more information on how to add support for another package. PRs welcome, see [CONTRIBUTING.md](https://github.com/TheCakeIsNaOH/choco-remixer/blob/master/CONTRIBUTING.md) for more information

Otherwise, open an [issue](https://github.com/TheCakeIsNaOH/choco-remixer/issues/new) to see if I am willing to add support.


## Why have internalization functionality?

- Because relying on software to be available at a specific URL on the internet in perpetuity is not a good idea for a number of reasons.
- Manually downloading and internalizing for each individual package version is huge amount of work for any quantity of packages.
- Allows (most) packages to work on offline/air gapped environments.
- Makes install a previous version always possible. Some software vendors only have their latest version available to download, in which case old package versions break.

## Why not use the Chocolatey official internalizer

- The [Chocolatey business license](https://chocolatey.org/pricing#faq-pricing) that has [automated internalization functionality](https://chocolatey.org/docs/features-automatically-recompile-packages):

   - Is not open source.
   - Starts at $1,600/year, which puts it out of reach for almost all non-business users.
   - Requires an ongoing license to continue to use the packages that are internalized with the business extension.


## Caveats

- I am still actively developing this, I make no promises that it is %100 stable.
- Packages are supported by whitelist, and support must be added individually for each package.

## Immediate TODOs

- Add support for internalizing package icons
- Comment based help for all public functions, specifically in Edit-InstallChocolateyPackage (platyps?)
- Module metadata creation, module install, other scripts
- Switch so invoke-internalizechocopkg can be run with a single chocolatey package

## Long term TODOs

- Module improvements, chocolatey package, powershell gallery?
- Async/Parallelize file searching, copying, packing, possibly downloading
- Ability to bump version of nupkg (fix version)
- Add option to trust names of nupkg's in searching, allows for quicker search
- Git integration for personal-packages.xml
- Multiple personal-packages.xml files (for now it probably is best to add an alias to your profile for each xml)
- Add capability to directly specify package internalization from xml with a separate function
- Pester, other testing?
- Drop dependency on `choco.exe`.
    - Move to `chocolatey.lib` instead?
	- Figure out why does not extract files that are added manually?
	- Alternate push? `chocolatey.lib`? Nexus API, will reduce compatibility? Dotnet?
    - Wait for dotnet core Chocolatey, and keep using it?

## Continuous TODOs

- Better verbose/debug and other information output
- generalize more functionality and make available as functions.
- Move more packages to no custom function, use generic functions
