// swift-tools-version:6.0

//
// This source file is part of the TemplatePackage open source project
// 
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
// 
// SPDX-License-Identifier: MIT
//

import PackageDescription

let package = Package(
    name: "SpeziCLAID",
    platforms: [
        .iOS(.v18),
        .macOS(.v15)
    ],
    products: [
        .library(name: "SpeziCLAID", targets: ["SpeziCLAID"])
    ],
    dependencies: [
        .package(path: "../CLAID"), // Local path reference
        .package(url: "https://github.com/StanfordSpezi/Spezi", from: "1.8.0"),
        .package(url: "https://github.com/StanfordSpezi/SpeziViews", from: "1.9.0"),
        .package(path: "/Users/planger/Development/SwiftPython")
    ],
    targets: [
        .target(
            name: "SpeziCLAID",
            dependencies: [
                "SwiftPython",
                .product(name: "CLAID", package: "CLAID"), // Correct way to reference CLAID
                .product(name: "Spezi", package: "Spezi"),
                .product(name: "SpeziViews", package: "SpeziViews")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        /*.target(name: "SpeziCLAIDNative",
                dependencies: [
                    .product(name: "CLAID", package: "CLAID") // Correct way to reference CLAID
                ],
                cxxSettings: [
                    .unsafeFlags(["-std=c++17"])
                ],
                swiftSettings: [.interoperabilityMode(.Cxx)]
        ),*/
        .testTarget(
            name: "SpeziCLAIDTests",
            dependencies: [
                .target(name: "SpeziCLAID")
            ]
        ) 
    ],
    cLanguageStandard: .c17,
    cxxLanguageStandard: .cxx17
)
