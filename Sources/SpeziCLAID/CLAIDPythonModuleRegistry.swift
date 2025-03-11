import Foundation
import SwiftPython
import PythonKit
import protocol Spezi.Module

import CLAID

@MainActor
public class CLAIDPythonModuleRegistry : SpeziModule {
    
    // Stores details about Python modules added to CLAID.
    // We use this information to let the PyCLAIDLoader
    // import the corresponding PythonFiles and add the
    // CLAID Python Modules to the Python Module factory.
    public var pythonModuleDetails: [PythonModuleDetails] = []
    // Holds a list of CLAID ModuleConfigs, which are normally extracted from
    // the JSON config file when loaded. During startup we merge these configs
    // with the config object loaded from the JSON file.
    public var additionalModulesConfig: [Claidservice_ModuleConfig] = []
        
    
    public init() {
        
    }
    
    /// Adds a new Python module to be loaded by CLAID
    /// - Parameters:
    ///   - pythonFilePath: Path to the Python file containing the module.
    ///   - pythonClass: Name of the Python module/class.
    ///   - moduleConfig: Additional configuration for the module.
    public func addPythonModule(
        pythonFilePath: String,
        pythonClass: String,
        moduleConfig: Claidservice_ModuleConfig
    ) {
        additionalModulesConfig.append(moduleConfig)
        pythonModuleDetails.append(
            PythonModuleDetails(
                pythonFilePath: pythonFilePath,
                pythonModuleName: pythonClass
            )
        )
    }
}
