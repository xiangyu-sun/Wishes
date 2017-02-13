import PackageDescription

let package = Package(
    name: "Wishes",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", Version(2, 0, 0, prereleaseIdentifiers: ["alpha"])),
        .Package(url: "https://github.com/vapor/mysql-provider.git", Version(2, 0, 0, prereleaseIdentifiers: ["alpha"])),
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
    ]
)

