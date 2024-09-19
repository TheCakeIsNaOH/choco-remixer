## Preliminary

First, check if the package is `internal` (also known as embedded). For a Chocolatey package, being `internal` means that it does not need to download binaries from external sources to work.
A package could be internal because it already includes the required binaries inside the `.nupkg`, or because it does not require binaries, for example [virtual package](https://docs.chocolatey.org/en-us/faqs#what-is-the-difference-between-packages-no-suffix-as-compared-to.install.portable) do not download binaries.

The simplest way to check if the package is internal is by seeing if there are any URL(s) in the `ChocolateyInstall.ps1` file.
If there are no URLs, or if there is no `ChocolateyInstall.ps1`, then the package is internal; got to the "Add an internal package" section.
However, if there are URL(s), then the package is most likely not internal; go to the "Add a non-internal package" section.
There can be false positives, as occasionally an internal package will have a URL in a comment as a reference documentation or something similar.

## Add an internal package

1. Get the `id` of the package. Not the name or `title`, but the `id`. The `id` is available in the `.nuspec`, and it is what is used to install/uninstall the package.
2. Open up `packages.xml`, and add the `id` to the `internal` section.
3. Commit the updated `packages.xml`
4. Open a PR

## Add a non-internal package

1. Get the `id` of the package. Not the name or `title`, but the `id`. The `id` is available in the `.nuspec`, and it is what is used to install/uninstall the package.
2. From here on out, everything will be referencing the `ChocolateyInstall.ps1` of the package, for brevity called the install script.
3. Check if the install script has the error action preference statement, if not note down
4. Check if the install script has defined the `$tooldDir` variable, if not note down
5. Check what helper is used to download the file(s). `Install-ChocolateyPackage`, `Install-ChocolateyZipPackage`, and `Get-ChocolateyWebfile` are the three most common. If it is a script that uses `Install-ChocolateyPackage`, then `Edit-InstallChocolateyPackage` may be able to be used. See the "Standard Install Type Packages" section below.
6. Check why the package is not internal. There are three major options: First, the license of the software might not allow redistribution. Second, the package could be over 200mb. Third, the maintainer might have decided to not make the package internal. In the third case, you might be better served by trying to get the maintainer to make the package internal instead of adding support for the package here.
7. Add an entry in `packages.xml` for the package under `<implemented>`. The `functionName`should normally be in the format `Convert-<package-id>`, the `id` is from step 1, the `needsStopAction` is from step 3, the `needsToolsDir` is from step 4. See the other entries for the formatting. It is (mostly) in alphabetical order according the `id`s.
8. Create the function for the package, the name of the function is `functionName`. See below for which file the function should go in. Look in that file for a general idea of what the function should look like. It should accept one argument called `$obj`. Also, see the sections below for more information on what the function needs to do.
- For `Install-ChocolateyPackage` it should go in `PkgFunctions-install.ps1`.
- For `Install-ChocolateyZipPackage`, or other packages extracting archives, it should go in `PkgFunctions-zip.ps1`
- For functions using `Get-ChocolateyWebfile`, put it in `PkgFunctions-webfile.ps1`
- For any other helper function (like `Install-WindowsUpdate`) or packages using other "interesting" scripts, use `PkgFunctions-special.ps1`
9. Test. Download the package, run using `-nopack -nosave`, check that the package is internalized correctly, specifically that all the files are downloaded, and that the `chocolateyInstall.ps1` is correctly edited. See the [CONTRIBUTING.md](https://github.com/TheCakeIsNaOH/choco-remixer/blob/master/CONTRIBUTING.md) for more information on how to setup a testing environment.
10. Commit your changes and make a PR.

## What the `Convert-<package-id>` needs to do

Each convert function has two major things it needs to do. First, it need to download any files from the install script. Second, it needs to edit the `$obj.installScriptMod` to use those downloaded files, instead of downloading them at runtime.

If the package uses a fairly standard `Install-ChocolateyPackage` layout, with argument splatting, and no extra things going on, you can use `Edit-InstallChocolateyPackage` via `Convert-InstallChocolateyPackage`. See the standard install package section.

Otherwise, the editing of the install script and getting the url(s) is a fairly manual process. For the actual downloading please use the helper function `Get-File`.

For `Get-File`, you need to get the url, the filename (normally the last part of the url, can be something manually defined if needed), the download directory (normally use `$obj.toolsDir`), the checksum of the file, and the checksum type. Normally, you can hardcode the checksum type, as that rarely changes between package versions. However, the url and the checksum normally need to be scraped from the script. See the other functions for how to do so.

If the script does anything with the downloaded file (e.g install, unzip, otherwise run), generally refer to it via a `Join-Path $toolsDir 'file.name'`, don't forget to make sure `$toolsDir` is defined in the script.

## What changes need to be made for each helper

### `Install-ChocolateyPackage`

For this one, replace with `Install-ChocolateyInstallPackage`, and replace the `url`/`url64` argument with `file`/`file64`. This is fairly easy if the script uses splatting, as then you can just add the file path to the hashtable, although it is more complex if it does not use splatting. In that case, it may be easier to completely comment out the `Install-ChocolateyPackage`, and add a new line for `Install-ChocolateyInstallPackage`

Don't forget to add something to remove the file(s) at the end of the install script, and anywhere else it `return`s or `throw`s.

### `Install-ChocolateyZipPackage`

Replace with `Get-ChocolateyUnzip`. Unfortunately, not only does the `url`/`url64` have to switched to `FileFullPath`/`FileFullPath64`, the `UnzipLocation` variable has to be renamed to `Destination` (facepalm, see [issue #2203](https://github.com/chocolatey/choco/issues/2203) for if it is fixed).

Again, similar to `Install-ChocolateyPackage`, you can just add the paths to the files if it uses splatting, otherwise it is probably easier to just comment it out and start fresh.

Don't forget to add something to remove the file(s) at the end of the install script, and anywhere else it `return`s or `throw`s.

### `Get-ChocolateyWebFile`

This can be the easiest but also sometimes about the same as other, as if it is just downloading a file where the file is unused for the rest of the script, you can just comment out `Get-ChocolateyWebFile`. Otherwise, if the file does end up being used, then make sure that the later things using it have the correct path. If was originally going to be downloaded to the `$toolsDir`, then it should be fine as is, but if was going to downloaded to `%temp%` or something, you may have to adjust things later in the script.

These files may or may not need to be removed at the end of the script, it depends on whether the files was a means to get the program installed (i.e. installer or archive or something), or if the file is the program itself.

### Other helpers

Case by case basis.

For `Install-WindowsUpdate`, still use `url`/`url64`, which does work with a local file path.

## Standard Install Type Packages

If a package uses the standard `Install-ChocolateyPackage` format, like `vscode.install`, `advanced-install` or quite a few other packages, then `Edit-InstallChocolateyPackage` can be used. It can either be used in a `Convert-<packageid>` function, or via `Convert-InstallChocolateyPackage`, specifying the arguments in `packages.xml`. See the `4k-slideshow-maker` package in `packages.xml` as an example.

## Edit-InstallChocolateyPackage documentation

This function edits the install script and downloads the installer(s) for standard formatted script using `Install-ChocolateyPackage`. It returns the modified/edited install script

## Required options
- `$architecture` is `x32`, `x64` or `both`, to set what urls are in the install script
- `$nuspecID` is the package ID
- `$version` is the package version
- `$installScript` is the unmodified install script
- `$toolsDir` is the folder the script file is in (Generally just `tools`)
- `$needsTools` is a switch if the `$toolsDir` definition needs to be added
- `$needsEA` is a switch if the stop action line needs to be added.
- `$checksumTypeType` is the checksum type, e.g. `sha256`, `sha512`, etc

## `$urltype` sets how to parse the url
- 0: `" Url "`, `" Url64Bit "`
- 1: `'^\$Url32 '`, `'^\$Url64 '`
- 2: `'^\$Url '`, `'^\$Url64 '`
- 3: `" Url "`, `" Url64 "`
- 4: `"Url "`, `"Url64 "`
- 5: `" Url32bit "`, `" Url64bit "`
- 6: `'\$url\s+='`, `'\$url64\s+='`
- 7: `'\s+url\s+='`, `'\s+url64\s+='`
- 8: `'\s+url32\s+='`, `'\s+url64\s+='`
- 9: `'\s+url\s+='`, `'\s+url64bit\s+='`

## `$argsType` sets how to parse the argument splatted for `Install-ChocolateyPackage`
- 0: for `packageArgs = @{`
- 1: for ` = @{`

## `$checksumArgsType` sets how to parse the url
- 0: `'  Checksum  '`,`'  Checksum64  '`
- 1: `'^\$checksum32 '`,`'^\$checksum64 '`
- 2: `'^\$checksum '`,`'^\$checksum64 '`
- 3: `'  checksum32  '`,`'  checksum64  '`
- 4: `' checksum '`,`' Checksum64 '`
- 5: `'\schecksum\s+='`,`'\schecksum64\s+='`
- 6: `'\schecksum\s+='`,`'\schecksum64\s+='` with double quotes url (legacy, use `$doubleQuotesChecksum` instead)
- 7: `'\$checksum\s+='`,`'\$checksum64\s+='`

## Misc other options
- `$doubleQuotesUrl`, if urls are surrounded by double quotes instead of single
- `$doubleQuotesChecksum`, if checksums are surrounded by double quotes instead of single
- `$stripQueryString`, to strip everything after `?` from the url
- `$DeEncodeSpace`, to switch `%20` to `" "`
- `$x64NameExt`, to add `_x64` to the 64 bit filename
- `$removeEXE`, to add a line to the end of the script that removes all `.exe` files from the tools directory
- `$removeMSI`, to add a line to the end of the script that removes all `.msi` files from the tools directory
- `$removeMSU`, to add a line to the end of the script that removes all `.msi` files from the tools directory
- `$replaceFilenames`, to use filenames in the format `<id>-<version>-<architecture>.<extension>` instead of filenames parsed from the download urls
- `$hasVersionUrl`, to use a seperate version variable in the package url

## `$versionUrlType` sets what type of version variable to use
- 0: `$version`, replacing `${version}`
- 1: `$PackageVersion` with "", replacing `$($PackageVersion)`
- 0: `$version` with "", replacing `${version}`