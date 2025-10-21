//////////////////////////////////////////////////////////////////////
// DIRECTIVES AND TOOLS
//////////////////////////////////////////////////////////////////////

#tool dotnet:?package=GitVersion.Tool&version=5.12.0
#addin nuget:?package=Cake.Docker&version=1.2.3
#addin nuget:?package=Cake.FileHelpers&version=6.1.3

//////////////////////////////////////////////////////////////////////
// USINGS
//////////////////////////////////////////////////////////////////////

using Cake.Common.Tools.DotNet;
using Cake.Common.Tools.DotNet.Build;
using Cake.Common.Tools.DotNet.Test;
using Cake.Common.Tools.DotNet.Pack;
using Cake.Common.Tools.DotNet.Restore;
using Cake.Common.Tools.DotNet.Clean;

//////////////////////////////////////////////////////////////////////
// ARGUMENTS
//////////////////////////////////////////////////////////////////////

var target = Argument("target", "Default");
var configuration = Argument("configuration", "Release");
var version = Argument("version", "1.0.0");

//////////////////////////////////////////////////////////////////////
// PREPARATION
//////////////////////////////////////////////////////////////////////

var solutionFile = "./Calculator.sln";
var serverProject = "./Calculator.Server/Calculator.Server.csproj";
var clientProject = "./Calculator.Client/Calculator.Client.csproj";
var testsProject = "./Calculator.Tests/Calculator.Tests.csproj";
var webProject = "./Calculator.Web";

var artifactsDir = "./artifacts";
var packagesDir = "./artifacts/packages";
var testResultsDir = "./artifacts/test-results";

//////////////////////////////////////////////////////////////////////
// TASKS
//////////////////////////////////////////////////////////////////////

Task("Clean")
    .Does(() =>
{
    CleanDirectory(artifactsDir);
    
    DotNetClean(solutionFile, new DotNetCleanSettings
    {
        Configuration = configuration
    });
    
    Information("✅ Clean completed");
});

Task("Restore")
    .IsDependentOn("Clean")
    .Does(() =>
{
    DotNetRestore(solutionFile);
    Information("✅ Restore completed");
});

Task("Build")
    .IsDependentOn("Restore")
    .Does(() =>
{
    DotNetBuild(solutionFile, new DotNetBuildSettings
    {
        Configuration = configuration,
        NoRestore = true,
        MSBuildSettings = new DotNetMSBuildSettings()
            .WithProperty("Version", version)
            .WithProperty("AssemblyVersion", version)
            .WithProperty("FileVersion", version)
    });
    
    Information("✅ Build completed");
});

Task("Test")
    .IsDependentOn("Build")
    .Does(() =>
{
    EnsureDirectoryExists(testResultsDir);
    
    DotNetTest(testsProject, new DotNetTestSettings
    {
        Configuration = configuration,
        NoBuild = true,
        NoRestore = true,
        ResultsDirectory = testResultsDir,
        Loggers = new[] { "trx", "console;verbosity=normal" }
    });
    
    Information("✅ Tests completed");
});

Task("Pack-Server")
    .IsDependentOn("Test")
    .Does(() =>
{
    EnsureDirectoryExists(packagesDir);
    
    DotNetPack(serverProject, new DotNetPackSettings
    {
        Configuration = configuration,
        NoBuild = true,
        NoRestore = true,
        OutputDirectory = packagesDir,
        MSBuildSettings = new DotNetMSBuildSettings()
            .WithProperty("Version", version)
            .WithProperty("PackageVersion", version)
    });
    
    Information("✅ Calculator.Server NuGet package created");
});

Task("Pack-Client")
    .IsDependentOn("Test")
    .Does(() =>
{
    EnsureDirectoryExists(packagesDir);
    
    DotNetPack(clientProject, new DotNetPackSettings
    {
        Configuration = configuration,
        NoBuild = true,
        NoRestore = true,
        OutputDirectory = packagesDir,
        MSBuildSettings = new DotNetMSBuildSettings()
            .WithProperty("Version", version)
            .WithProperty("PackageVersion", version)
    });
    
    Information("✅ Calculator.Client NuGet package created");
});

Task("Pack-Web")
    .Does(() =>
{
    var webPackageDir = $"{packagesDir}/web";
    EnsureDirectoryExists(webPackageDir);
    
    // Build Angular application
    StartProcess("npm", new ProcessSettings
    {
        Arguments = "ci",
        WorkingDirectory = webProject
    });
    
    StartProcess("npm", new ProcessSettings
    {
        Arguments = "run build",
        WorkingDirectory = webProject
    });
    
    // Create npm package
    StartProcess("npm", new ProcessSettings
    {
        Arguments = "pack",
        WorkingDirectory = webProject
    });
    
    // Move package to artifacts
    var packageFiles = GetFiles($"{webProject}/*.tgz");
    foreach(var packageFile in packageFiles)
    {
        MoveFile(packageFile, $"{webPackageDir}/{packageFile.GetFilename()}");
    }
    
    Information("✅ Calculator.Web npm package created");
});

Task("Pack")
    .IsDependentOn("Pack-Server")
    .IsDependentOn("Pack-Client")
    .IsDependentOn("Pack-Web")
    .Does(() =>
{
    Information("✅ All packages created successfully");
    
    var nugetPackages = GetFiles($"{packagesDir}/*.nupkg");
    var npmPackages = GetFiles($"{packagesDir}/web/*.tgz");
    
    Information($"📦 Created {nugetPackages.Count()} NuGet packages:");
    foreach(var package in nugetPackages)
    {
        Information($"   - {package.GetFilename()}");
    }
    
    Information($"📦 Created {npmPackages.Count()} npm packages:");
    foreach(var package in npmPackages)
    {
        Information($"   - {package.GetFilename()}");
    }
});

Task("Publish-NuGet")
    .IsDependentOn("Pack")
    .Does(() =>
{
    var nugetApiKey = EnvironmentVariable("NUGET_API_KEY");
    var nugetSource = EnvironmentVariable("NUGET_SOURCE") ?? "https://api.nuget.org/v3/index.json";
    
    if (string.IsNullOrEmpty(nugetApiKey))
    {
        Warning("⚠️  NUGET_API_KEY environment variable not set. Skipping NuGet publish.");
        return;
    }
    
    var nugetPackages = GetFiles($"{packagesDir}/*.nupkg");
    
    foreach(var package in nugetPackages)
    {
        StartProcess("dotnet", $"nuget push {package} --api-key {nugetApiKey} --source {nugetSource}");
        Information($"✅ Published {package.GetFilename()} to NuGet");
    }
});

Task("Publish-npm")
    .IsDependentOn("Pack")
    .Does(() =>
{
    var npmToken = EnvironmentVariable("NPM_TOKEN");
    var npmRegistry = EnvironmentVariable("NPM_REGISTRY") ?? "https://registry.npmjs.org/";
    
    if (string.IsNullOrEmpty(npmToken))
    {
        Warning("⚠️  NPM_TOKEN environment variable not set. Skipping npm publish.");
        return;
    }
    
    // Configure npm authentication
    StartProcess("npm", new ProcessSettings
    {
        Arguments = $"config set //registry.npmjs.org/:_authToken {npmToken}",
        WorkingDirectory = webProject
    });
    
    // Publish package
    StartProcess("npm", new ProcessSettings
    {
        Arguments = "publish",
        WorkingDirectory = webProject
    });
    
    Information("✅ Published Angular package to npm");
});

Task("Publish")
    .IsDependentOn("Publish-NuGet")
    .IsDependentOn("Publish-npm")
    .Does(() =>
{
    Information("✅ All packages published successfully");
});

Task("Docker-Build")
    .IsDependentOn("Test")
    .Does(() =>
{
    var dockerSettings = new DockerImageBuildSettings
    {
        Tag = new[] { $"calculator-server:{version}", "calculator-server:latest" },
        File = "./Calculator.Server/Dockerfile"
    };
    
    DockerBuild(dockerSettings, ".");
    
    dockerSettings = new DockerImageBuildSettings
    {
        Tag = new[] { $"calculator-client:{version}", "calculator-client:latest" },
        File = "./Calculator.Client/Dockerfile"
    };
    
    DockerBuild(dockerSettings, ".");
    
    dockerSettings = new DockerImageBuildSettings
    {
        Tag = new[] { $"calculator-web:{version}", "calculator-web:latest" },
        File = "./Calculator.Web/Dockerfile"
    };
    
    DockerBuild(dockerSettings, ".");
    
    Information("✅ Docker images built successfully");
});

Task("CI")
    .IsDependentOn("Pack")
    .IsDependentOn("Docker-Build")
    .Does(() =>
{
    Information("✅ CI pipeline completed successfully");
});

Task("CD")
    .IsDependentOn("CI")
    .IsDependentOn("Publish")
    .Does(() =>
{
    Information("✅ CD pipeline completed successfully");
});

//////////////////////////////////////////////////////////////////////
// TARGETS
//////////////////////////////////////////////////////////////////////

Task("Default")
    .IsDependentOn("Pack");

//////////////////////////////////////////////////////////////////////
// EXECUTION
//////////////////////////////////////////////////////////////////////

RunTarget(target);