//
// This source file is part of the TemplatePackage open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import SpeziCLAID
import CLAID

@main
struct UITestsApp: App {
    
    let claidRunner = CLAIDRunner(
        configFile: Bundle.main.url(forResource: "test_config", withExtension: "json")!.path,
        host: "testHost",
        user: "testUser",
        device: "testDevice",
        moduleFactoryRegisration: {
            
            let moduleFactory = ModuleFactory()
            
            do {
                try moduleFactory.registerModule(TestMod.self)
            } catch {
                
            }
            return moduleFactory
        }
    )
    
    
    var body: some Scene {
        WindowGroup {
            Text(SpeziCLAID().stanford)
        }
    }
}
