//
//  SpeziCLAIDModule.swift
//  SpeziCLAID
//
//  Created by Patrick Langer on 15.03.2025.
//


import protocol CLAID.Module
import protocol Spezi.Module

import class CLAID.ModuleHandle
import class CLAID.RemoteFunction
import struct CLAID.Claidservice_ModuleConfig
import class CLAID.Properties

import SwiftProtobuf



public protocol SpeziCLAIDModule : CLAID.Module, Spezi.Module {
    
   
    @MainActor init(moduleId: String, properties: [String: String], inputChannels: [String: String], outputChannels: [String:String])
}

extension SpeziCLAIDModule {


    
    @MainActor
    public init(
        moduleId: String,
        properties: [String : String] = [:],
        inputChannels: [String : String] = [:],
        outputChannels: [String : String] = [:]
    )  {
        self.init()
        CLAIDRuntime.moduleRegistry.addPreloadedSwiftModule(
            moduleId: moduleId,
            module:self,
            properties: properties,
            inputChannels: inputChannels,
            outputChannels: outputChannels
        )
    }

}
