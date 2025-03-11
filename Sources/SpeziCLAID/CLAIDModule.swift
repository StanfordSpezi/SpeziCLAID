//
//  CLAIDRunner.swift
//  SpeziCLAID
//
//  Created by Patrick Langer on 05.03.2025.
//

import Foundation
import SwiftPython
import PythonKit
import protocol Spezi.Module
typealias SpeziModule = Module
import CLAID

@MainActor
public class CLAIDModule : SpeziModule {
        
    func getTestConfigPath() -> String? {
            // Get the path to the resource inside the Swift package
            if let fileURL = Bundle.main.url(forResource: "test_config", withExtension: "json") {
                return fileURL.path // Convert URL to a file path string
            }
            print("Test config not found!!")
            return nil
    }
    
    func start() {
        SwiftPython.startPythonInterpreter()
        let sys = Python.import("sys")
        let text = ("Python \(sys.version_info.major).\(sys.version_info.minor)")
        print(text)
        
        if let scriptDirectory = Bundle.main.resourcePath {
            print("Script directory is \(scriptDirectory)")
                    
            // Add default dependencies packaged into the App to the PythonInterpreter.
            let packageDirectory = "\(scriptDirectory)/Frameworks/claid_native_xcframework.framework/"
            print("Adding \(packageDirectory)")
            sys.path.append(packageDirectory)
            
            let bundleDir = "\(scriptDirectory)/SpeziCLAID_SpeziCLAID.bundle"
            print("Adding \(bundleDir)")
            sys.path.append(bundleDir)
        }
        
        
        Task.detached {
            await self.asyncInit()
        }
    }
    
    @MainActor
    func asyncInit() async {
        do {
            
            if let testConfigPath = getTestConfigPath(){
                
                try await CLAID.registerModule(TestMod.self)
                
                try await CLAID.start(
                    configFile: testConfigPath,
                    hostID: "testHost",
                    userID: "test_user",
                    deviceID: "test_device"
                )
                let pythonCLAID = Python.import("claid_start")
                let _ = pythonCLAID.start()
            }
            else {
                print("Failed to get path to test config file.")
            }
            
        } catch {
            print("Error starting CLAID: \(error)")
        }
    }
    
    
    public init() {
        
    }
    
    public func configure() {
        start()
    }
}
