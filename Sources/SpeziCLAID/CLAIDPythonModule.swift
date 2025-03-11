//
//  CLAIDPythonModule.swift
//  SpeziCLAID
//
//  Created by Patrick Langer on 10.03.2025.
//

import struct CLAID.Claidservice_ModuleConfig
import Spezi

@MainActor
class CLAIDPythonModule : Module {
    @Dependency var claidDependency = CLAIDModule()
    
    private let pythonModuleFile: String
    private let pythonModuleClass: String
    private let pythonModuleId: String
    private let moduleProperties: Dictionary<String, String>
    private let inputChannels: Dictionary<String, String>
    private let outputChannels: Dictionary<String, String>
    private var moduleConfig: Claidservice_ModuleConfig
   
    public init(
        pythonModuleFile: String,
        pythonModuleClass: String,
        pythonModuleId: String,
        moduleProperties: Dictionary<String, String> = [:],
        inputChannels: Dictionary<String, String> = [:],
        outputChannels: Dictionary<String, String> = [:]
    ) {
        self.pythonModuleFile = pythonModuleFile
        self.pythonModuleClass = pythonModuleClass
        self.pythonModuleId = pythonModuleId
        self.moduleProperties = moduleProperties
        self.inputChannels = inputChannels
        self.outputChannels = outputChannels
        
        self.moduleConfig = Claidservice_ModuleConfig()
        self.moduleConfig.id = ""
    }
    
    public func configure() {
        
    }
}
