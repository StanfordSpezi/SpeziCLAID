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
public class CLAIDPythonModule : Module {
    @Dependency var claidDependency = CLAIDPythonModuleRegistry()
    
    private let pythonModuleFile: String
    private let pythonModuleClass: String
    private let pythonModuleId: String
    private let moduleProperties: Dictionary<String, String>
    private let inputChannels: Dictionary<String, String>
    private let outputChannels: Dictionary<String, String>
    private var moduleConfig: Claidservice_ModuleConfig
   
    private func dictionaryToProtobufStruct(_ dictionary: [String: String]) -> Google_Protobuf_Struct {
        var protobufStruct = Google_Protobuf_Struct()

        for (key, value) in dictionary {
            var protobufValue = Google_Protobuf_Value()
            protobufValue.stringValue = value
            protobufStruct.fields[key] = protobufValue
        }

        return protobufStruct
    }
    
    public init(
        pythonModuleFile: String,
        pythonModuleClass: String,
        pythonModuleId: String,
        moduleProperties: Dictionary<String, String> = [:],
        inputChannels: Dictionary<String, String> = [:],
        outputChannels: Dictionary<String, String> = [:]
    ) {
        print("CLAIDPythonModule init")
        self.pythonModuleFile = pythonModuleFile
        self.pythonModuleClass = pythonModuleClass
        self.pythonModuleId = pythonModuleId
        self.moduleProperties = moduleProperties
        self.inputChannels = inputChannels
        self.outputChannels = outputChannels
        
        self.moduleConfig = Claidservice_ModuleConfig()
        self.moduleConfig.type = pythonModuleClass
        self.moduleConfig.id = pythonModuleId
        self.moduleConfig.properties = dictionaryToProtobufStruct(moduleProperties)
        self.moduleConfig.inputChannels = inputChannels
        self.moduleConfig.outputChannels = outputChannels
        
        print("Init")
        // Add the Module to the CLAID config.
        
    }
    
    public func configure() {
        print("CLAIDPythonModule.configure")
        claidDependency.addPythonModule(
            pythonFilePath: self.pythonModuleFile,
            pythonClass: self.pythonModuleClass,
            moduleConfig: self.moduleConfig
        )
        
    }
}
