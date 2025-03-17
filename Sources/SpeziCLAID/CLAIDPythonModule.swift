//
//  CLAIDPythonModule.swift
//  SpeziCLAID
//
//  Created by Patrick Langer on 10.03.2025.
//

import struct CLAID.Claidservice_ModuleConfig
import Spezi
import SwiftProtobuf

@MainActor
open class CLAIDPythonModule : Module {
    
    
    public init(
        pythonModuleFile: String,
        pythonModuleClass: String,
        pythonModuleId: String,
        moduleProperties: Dictionary<String, String> = [:],
        inputChannels: Dictionary<String, String> = [:],
        outputChannels: Dictionary<String, String> = [:]
    ) {
        CLAIDRuntime.moduleRegistry.addPythonModule(
            pythonModuleFile: pythonModuleFile,
            pythonModuleClass: pythonModuleClass,
            pythonModuleId: pythonModuleId,
            moduleProperties: moduleProperties,
            inputChannels: inputChannels,
            outputChannels: outputChannels
        )
    }
    @MainActor
    public func configure() {
        
        
    }
}
