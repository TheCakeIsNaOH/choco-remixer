## Preliminary

First, check if the package is `internal`. For a Chocolatey package, being `internal` means that it does not need to download binaries from external sources to work. 
A package could be internal because it already includes the required binaries inside the `.nupkg`, or because it does not require binaries, for example [virtual package](https://docs.chocolatey.org/en-us/faqs#what-is-the-difference-between-packages-no-suffix-as-compared-to.install.portable)

The simplest way to check if the package is internal is by seeing if there are any URL(s) in the `ChocolateyInstall.ps1` file. 
If there are no URLs, or if there is no `ChocolateyInstall.ps1`, then the package is internal; got to the "Add an internal package" section.
However, if there are URL(s), then the package is most likely not internal; go to the "Add a non-internal package" section. 
There can be false positives, as occasionally an internal package will have a URL in a comment for reference documentation or similar.

## Add an internal package

1. Get the `id` of the package. Not the name or `title`, but the `id`. The `id` is available in the `.nuspec`, and it is what is used to install/uninstall the package.
2. Open up `packages.xml`, and add the `id` to the `internal` section.
3. Commit the updated `packages.xml`
4. Open a PR

## Add a non-internal package

1. Get the `id` of the package. Not the name or `title`, but the `id`. The `id` is available in the `.nuspec`, and it is what is used to install/uninstall the package.

TO FINISH