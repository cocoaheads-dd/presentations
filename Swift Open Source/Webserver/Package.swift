import PackageDescription

let package = Package(
    name: "Webserver",
    dependencies: [
        .Package(url: "https://github.com/Zewo/Epoch.git", majorVersion: 0, minor: 1)
    ]
)
