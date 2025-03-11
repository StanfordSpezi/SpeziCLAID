//
// This source file is part of the TemplatePackage open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//
import Spezi
import SwiftUI


@main
struct ExampleApp: App {
    @ApplicationDelegateAdaptor(TestAppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .spezi(appDelegate)
        }
    }
    
}
