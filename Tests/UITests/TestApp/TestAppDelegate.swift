//
//  TestAppDelegate.swift
//  SpeziCLAID
//
//  Created by Patrick Langer on 10.03.2025.
//


import Spezi
import SpeziCLAID
import Foundation


class TestAppDelegate: SpeziAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: ExampleStandard()) {
            CLAIDPythonModule(
                pythonModuleFile: "MyAggregator.py",
                pythonModuleClass: "MyAggregator",
                pythonModuleId: "SomeModuleIWantToTest"
            )
            CLAIDRuntime()
        }
    }
    

}
