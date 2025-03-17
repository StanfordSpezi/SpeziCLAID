import Foundation
import SwiftPython
import PythonKit

import CLAID
import SwiftProtobuf

public class CLAIDRegistry  {
    
    // Stores details about Python modules added to CLAID.
    // We use this information to let the PyCLAIDLoader
    // import the corresponding PythonFiles and add the
    // CLAID Python Modules to the Python Module factory.
    public var pythonModuleDetails: [PythonModuleDetails] = []
    // Holds a list of CLAID ModuleConfigs, which are normally extracted from
    // the JSON config file when loaded. During startup we merge these configs
    // with the config object loaded from the JSON file.
    public var moduleConfigurations: [Claidservice_ModuleConfig] = []
    public var preloadedCLAIDModules: [String:Module] = [:]
    
    private func makeModuleConfig(
        moduleId: String,
        moduleType: String,
        properties: [String: String],
        inputChannels: [String: String] = [:],
        outputChannels: [String:String] = [:]
    ) -> Claidservice_ModuleConfig {
        var moduleConfig = Claidservice_ModuleConfig()
        moduleConfig.type = moduleType
        moduleConfig.id = moduleId
        
        var protobufStruct = Google_Protobuf_Struct()
        for (key, value) in properties {
            var protobufValue = Google_Protobuf_Value()
            protobufValue.stringValue = value
            protobufStruct.fields[key] = protobufValue
        }
        moduleConfig.properties = protobufStruct
        moduleConfig.inputChannels = inputChannels
        moduleConfig.outputChannels = outputChannels
        
        return moduleConfig
    }
    
    public init() {
        
    }
    
    /// Adds a new Python module to be loaded by CLAID
    /// - Parameters:
    ///   - pythonFilePath: Path to the Python file containing the module.
    ///   - pythonClass: Name of the Python module/class.
    ///   - moduleConfig: Additional configuration for the module.
    public func addPythonModule(
        pythonModuleFile: String,
        pythonModuleClass: String,
        pythonModuleId: String,
        moduleProperties: Dictionary<String, String> = [:],
        inputChannels: Dictionary<String, String> = [:],
        outputChannels: Dictionary<String, String> = [:]
    ) {
        let moduleConfig = makeModuleConfig(
            moduleId: pythonModuleId,
            moduleType: pythonModuleClass,
            properties: moduleProperties,
            inputChannels: inputChannels,
            outputChannels: outputChannels
        )
        
        moduleConfigurations.append(moduleConfig)
        pythonModuleDetails.append(
            PythonModuleDetails(
                pythonFilePath: pythonModuleFile,
                pythonModuleName: pythonModuleClass
            )
        )
    }
    
    public func addSwiftModule(
        moduleConfig: Claidservice_ModuleConfig
    ) {
        print("Adding swift Module \(moduleConfig)")
        moduleConfigurations.append(moduleConfig)
    }
    
    @MainActor
    public func addPreloadedSwiftModule(
        moduleId: String,
        module: Module,
        properties: [String: String],
        inputChannels: [String: String] = [:],
        outputChannels: [String:String] = [:]
    ) {
        let moduleClass: String = String(describing: type(of: module))

        let moduleConfig = makeModuleConfig(
            moduleId: moduleId,
            moduleType: moduleClass,
            properties: properties,
            inputChannels: inputChannels,
            outputChannels: outputChannels
        )
        
        self.addSwiftModule(moduleConfig: moduleConfig)
        self.preloadedCLAIDModules[moduleConfig.id] = module
    }
    
    
}
