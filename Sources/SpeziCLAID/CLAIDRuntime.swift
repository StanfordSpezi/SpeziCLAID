import Foundation
import SwiftPython
import PythonKit
import protocol Spezi.Module

import CLAID




@MainActor
public class CLAIDRuntime: Spezi.Module {
    
    public static var moduleRegistry = CLAIDRegistry()
    
    
    private let patchedCLAIDConfig: String = "patched_config.json"
    private var patchedCLAIDConfigPath: String = ""
    
    //private let moduleRegistrationFunc: () async throws -> Void
    // Reference to the PyCLAIDLoader module instance defined in "PyCLAIDLoader.py".
    private var pyCLAIDLoader: PythonObject?
    
    private var config = Claidservice_CLAIDConfig()
    private let hostName: String
    private let userName: String
    private let deviceId: String
    
    /// Retrieves the path to the CLAID configuration stub file inside the app bundle
    /// - Returns: Path to the configuration file if found, otherwise throws an error
    func getCLAIDConfigStubPath() throws -> String? {
        guard let fileURL = Bundle.main.url(forResource: "claid_main_config", withExtension: "json") else {
            throw CLAIDError("Could not find claid_main_config.json in bundle.")
        }
        return fileURL.path
    }
    
    /// Loads the CLAID config from the specified path, then looks up the host and adds the additional Modules to it.
    /// Finally, stores the new config to a different file
    func writeOutCLAIDConfig(
        config: Claidservice_CLAIDConfig
    ) throws {
        let tempDirectory = FileManager.default.temporaryDirectory
        let tempOutputPath = tempDirectory.appendingPathComponent(patchedCLAIDConfig).path
        self.patchedCLAIDConfigPath = tempOutputPath
        
        // Serialize back to JSON
        let jsonData = try config.jsonUTF8Data()
        
        // Save to output path
        try jsonData.write(to: URL(fileURLWithPath: self.patchedCLAIDConfigPath))
    }
    
    /// Asynchronous initialization of CLAID using configuration stub
    @MainActor
    func startCLAIDFramework() async {
        do {
            print("Calling module registration func")
            
            for (moduleId, module) in CLAIDRuntime.moduleRegistry.preloadedCLAIDModules {
                print("preloading \(moduleId) of type \(String(describing: type(of: module)))")
                try await CLAID.registerModule(type(of: module))
                await CLAID.addPreloadedModule(moduleId: moduleId, module: module)
            }
            
           // try await self.moduleRegistrationFunc()
            // Start CLAID with test configuration
            try await CLAID.start(
                configFile: patchedCLAIDConfigPath,
                hostID: self.hostName,
                userID: "test_user",
                deviceID: "test_device"
            )
            
            // Ensure pyCLAID is initialized and start it
            guard let pyCLAIDLoader = self.pyCLAIDLoader else {
                throw CLAIDError("Failed to start pyCLAID, object is null.")
            }
            _ = pyCLAIDLoader.attach_python_runtime()
        } catch {
            print("Error starting CLAID: \(error)")
        }
    }
    
    func setUpPythonDependencies() throws {
        SwiftPython.startPythonInterpreter()
        let sys = Python.import("sys")
        // Ensure the script directory exists in the app bundle
        if let scriptDirectory = Bundle.main.resourcePath {
            
            // Add necessary paths for Python dependencies.
            // The claid_native framework contains the implementation of the Python runtime.
            // Normally, this is available as pip package (pip install CLAID).
            let packageDirectory = "\(scriptDirectory)/Frameworks/claid_native_xcframework.framework/"
            sys.path.append(packageDirectory)
            
            // This folder contains the PyCLAIDLoader.py, so we have to add it to the Python path.
            let bundleDir = "\(scriptDirectory)/SpeziCLAID_SpeziCLAID.bundle/Python"
            sys.path.append(bundleDir)
            
            // Add the current Bundle as path as well, enabling us to import Python files from the Resources.
            sys.path.append(scriptDirectory)
            
            self.pyCLAIDLoader = Python.import("PyCLAIDLoader")
            
            // Ensure pyCLAID is successfully imported
            guard let pyCLAIDLoader = self.pyCLAIDLoader else {
                throw CLAIDError("Failed to start pyCLAID, failed to import PyCLAIDLoader, object is null.")
            }
            
            // Import and add each registered Python module
            try CLAIDRuntime.moduleRegistry.pythonModuleDetails.forEach { moduleInfo in
                let result = pyCLAIDLoader.import_and_add_module(
                    scriptDirectory,
                    moduleInfo.pythonFilePath,
                    moduleInfo.pythonModuleName
                )
                
                if Bool(result) == false {
                    throw CLAIDError("Failed to import PythonModule \(moduleInfo.pythonModuleName) from file \(moduleInfo.pythonFilePath)." +
                                     "File not found or does not contain class '\(moduleInfo.pythonModuleName)'. Check files under \(scriptDirectory).")
                }
            }
        }
        
    }
    
  
    
    /// Initializes the Python interpreter and starts CLAID
    /// - Throws: CLAIDError if initialization fails
    public func start() throws {
        try setUpPythonDependencies()
        try writeOutCLAIDConfig(config: self.config)
        
        // Start asynchronous initialization.
        Task {
            await self.startCLAIDFramework()
        }
    }

        
    /// Default initializer for the CLAIDModule
    public init(hostName: String, userName: String, deviceId: String) {
        // self.moduleRegistrationFunc = registerModules
        self.hostName = hostName
        self.userName = userName
        self.deviceId = deviceId
        
        self.config = Claidservice_CLAIDConfig()
        var hostconfig = Claidservice_HostConfig()
        hostconfig.hostname = hostName
        hostconfig.modules = CLAIDRuntime.moduleRegistry.moduleConfigurations
        
        self.config.hosts.append(hostconfig)
   }
    
    /// Configures and starts the CLAID module
    /// - Throws: CLAIDError if initialization fails
    public func configure() {
        print("CLAIDModule configure")
        do {
            try start()
        } catch {
            print("CLAIDModule configure error: \(error)")
        }
    }
    
    
}
