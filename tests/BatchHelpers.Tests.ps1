# Tests for the URL-building helpers extracted from RepoMove/RepoCheck/DownloadChocoPkg.
Import-Module (Join-Path $PSScriptRoot '..\choco-remixer\choco-remixer.psm1') -Force

InModuleScope choco-remixer {
    Describe 'Get-NexusRepoParts' {
        It 'splits a standard Nexus repository URL' {
            $parts = Get-NexusRepoParts -RepoUrl 'https://nexus.example.com/repository/choco-proxy/'
            $parts.BaseURL | Should -Be 'https://nexus.example.com/'
            $parts.RepoName | Should -Be 'choco-proxy'
        }

        It 'handles repo names containing the word repository' {
            $parts = Get-NexusRepoParts -RepoUrl 'https://nexus.example.com/repository/my-repository/'
            $parts.BaseURL | Should -Be 'https://nexus.example.com/'
            $parts.RepoName | Should -Be 'my-repository'
        }

        It 'tolerates a missing trailing slash' {
            $parts = Get-NexusRepoParts -RepoUrl 'https://nexus.example.com/repository/choco-proxy'
            $parts.RepoName | Should -Be 'choco-proxy'
        }
    }

    Describe 'New-NexusSearchUrl' {
        It 'builds a Nexus search URL with encoded parameters' {
            New-NexusSearchUrl -ApiBase 'https://nexus.example.com/service/rest/v1/' -RepoName 'choco-proxy' -PackageId 'my pkg' -Version '1.0.0' |
                Should -Be 'https://nexus.example.com/service/rest/v1/search?repository=choco-proxy&format=nuget&name=my%20pkg&version=1.0.0'
        }

        It 'encodes special characters in ids and versions' {
            New-NexusSearchUrl -ApiBase 'https://nexus.example.com/service/rest/v1/' -RepoName 'choco-proxy' -PackageId 'a&b' -Version '1.0.0-beta+01' |
                Should -Be 'https://nexus.example.com/service/rest/v1/search?repository=choco-proxy&format=nuget&name=a%26b&version=1.0.0-beta%2B01'
        }

        It 'appends a trailing slash to the API base when missing' {
            New-NexusSearchUrl -ApiBase 'https://nexus.example.com/service/rest/v1' -RepoName 'r' -PackageId 'p' -Version '1.0' |
                Should -Be 'https://nexus.example.com/service/rest/v1/search?repository=r&format=nuget&name=p&version=1.0'
        }
    }

    Describe 'New-ChocoODataFilterUrl' {
        It 'builds an encoded OData filter URL' {
            New-ChocoODataFilterUrl -ApiBase 'https://community.chocolatey.org/api/v2/' -PackageId 'my pkg' -Filter 'IsLatestVersion' |
                Should -Be 'https://community.chocolatey.org/api/v2/Packages()?$filter=%28tolower%28Id%29%20eq%20%27my%20pkg%27%29%20and%20IsLatestVersion'
        }

        It 'doubles single quotes in the package id' {
            New-ChocoODataFilterUrl -ApiBase 'https://community.chocolatey.org/api/v2/' -PackageId "it's" -Filter 'IsLatestVersion' |
                Should -Be 'https://community.chocolatey.org/api/v2/Packages()?$filter=%28tolower%28Id%29%20eq%20%27it%27%27s%27%29%20and%20IsLatestVersion'
        }

        It 'supports the IsAbsoluteLatestVersion filter' {
            New-ChocoODataFilterUrl -ApiBase 'https://community.chocolatey.org/api/v2/' -PackageId 'testpkg' -Filter 'IsAbsoluteLatestVersion' |
                Should -Be 'https://community.chocolatey.org/api/v2/Packages()?$filter=%28tolower%28Id%29%20eq%20%27testpkg%27%29%20and%20IsAbsoluteLatestVersion'
        }
    }
}