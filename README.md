## Requirements

- PowerShell - tested so far with v5.1 on windows, should be compatible with 6+ and other OSes without too much effort
- `choco` on your path
- Chocolatey `.nupgk` files that do not include all files in the package.
- A local chocolatey repository. Proget is ideal

## Setup 

- Copy `personal-packages-template.xml` to `personal-packages.xml` and open it.
- Set `downloadDir` to the directory your `.nupkg` files to internalize are.
- Set `internalizedDir` to the directory where you want the `.nupkg`s to be internalized in.
- If you have any custom packages, their IDs can be added to the personal section

## Operation 

- Run `Internalize-ChocoPkg.ps1` in PowerShell
- When it has completed, check in the `internalizedDir` that the packages have downloaded files correctly and modified the `chocolateyinstall.ps1` files as needed.
- Push the packages to your local repository, or in the case of Proget, copy to the drop path.

## Caveats

- This is alpha software, please do not use in production (yet).
- Packages are supported by whitelist, and support must be added individually for each package. Only a limited subset of packages that would need internalization are supported at this moment.
- Error checking and logging are limited

## Todo

- Extract files individually rather then extracting all and removing excess
- Checksum downloads
- Logging, and support verbose
- Error checking and handling
- Turn into proper module
- Automatic push/copy and auto add to personal packages, todo after error checking is much better
- Make individual package functions better
- Speed up searching for `.nupkgs`
    ### Long term
  
  - Async/Parallelize file searching, copying, packing, possibly downloading 
  - Drop dependency on `choco`, possibly requires chocolatey to update the nuget.exe version as current version does not extract files added to zip.
  - Ability to bump version of nupkg