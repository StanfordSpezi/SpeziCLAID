//
//  TestAppDelegate.swift
//  SpeziCLAID
//
//  Created by Patrick Langer on 10.03.2025.
//


import Spezi
import SpeziCLAID
import Foundation
import CLAID

class TestAppDelegate: SpeziAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: ExampleStandard()) {
            
            // Add a Module from Python code using the generic CLAIDPythonModule.
            CLAIDPythonModule(
                pythonModuleFile: "SomePythonTestModule.py",
                pythonModuleClass: "SomePythonTestModule",
                pythonModuleId: "Test123"
            )
            
            // Add the SleepDataAggregator, which is a Python Module.
            // It simply inherits from CLAIDPythonModule and already sets the path to the correct file.
            SleepAggregatorPy(moduleId: "SleepDataAggregator")
            
            // Add the SleepAnalyzer, which is a CLAID Swift Module. 
            SleepAnalyzer(moduleId: "SleepAnalyzer")
            CLAIDRuntime(hostName: "MyHost", userName: "MyUser", deviceId: "Device")
        }
    }
    

}
