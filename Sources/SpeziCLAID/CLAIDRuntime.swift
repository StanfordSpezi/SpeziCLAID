import Foundation
import SwiftPython
import PythonKit
import protocol Spezi.Module

typealias SpeziModule = Module
import CLAID

@MainActor
public class CLAIDRuntime : SpeziModule {
    
    @Dependency var moduleRegistry = CLAIDPythonModuleRegistry()
    
    private let defaultHostName: String = "default_host"
    private let patchedCLAIDConfig: String = "patched_config.json"
    private var patchedCLAIDConfigPath: String = ""
    // Reference to the PyCLAIDLoader module instance defined in "PyCLAIDLoader.py".
    private var pyCLAIDLoader: PythonObject?
    
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
    func updateCLAIDConfig(
        inputPath: String,
        hostName: String,
        modules: [Claidservice_ModuleConfig],
        outputPath: String
    ) throws {
        // Read the JSON file
        let jsonData = try Data(contentsOf: URL(fileURLWithPath: inputPath))
        
        // Deserialize JSON to CLAIDConfig
        var claidConfig = try Claidservice_CLAIDConfig(jsonUTF8Data: jsonData)
        
        // Find the host and add the modules
        if let index = claidConfig.hosts.firstIndex(where: { $0.hostname == hostName }) {
            claidConfig.hosts[index].modules.append(contentsOf: modules)
        } else {
            throw CLAIDError("Unable to find host \(hostName) in configuration file \(inputPath)")
        }
        
        // Serialize back to JSON
        let updatedJsonData = try claidConfig.jsonUTF8Data()
        
        // Save to output path
        try updatedJsonData.write(to: URL(fileURLWithPath: outputPath))
    }
    
    /// Asynchronous initialization of CLAID using configuration stub
    @MainActor
    func startCLAIDFramework() async {
        do {
            // Start CLAID with test configuration
            try await CLAID.start(
                configFile: patchedCLAIDConfigPath,
                hostID: defaultHostName,
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
            let bundleDir = "\(scriptDirectory)/SpeziCLAID_SpeziCLAID.bundle"
            sys.path.append(bundleDir)
            
            // Add the current Bundle as path as well, enabling us to import Python files from the Resources.
            sys.path.append(scriptDirectory)
            
            self.pyCLAIDLoader = Python.import("PyCLAIDLoader")
            
            // Ensure pyCLAID is successfully imported
            guard let pyCLAIDLoader = self.pyCLAIDLoader else {
                throw CLAIDError("Failed to start pyCLAID, failed to import PyCLAIDLoader, object is null.")
            }
            
            // Import and add each registered Python module
            try moduleRegistry.pythonModuleDetails.forEach { moduleInfo in
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
    
    func patchCLAIDConfig() throws {
        guard let testConfigPath = try getCLAIDConfigStubPath() else {
            throw CLAIDError("Failed to update CLAID config, cannot retrieve config path.")
        }
        let tempDirectory = FileManager.default.temporaryDirectory
        let tempOutputPath = tempDirectory.appendingPathComponent(patchedCLAIDConfig).path
        self.patchedCLAIDConfigPath = tempOutputPath
        
        try updateCLAIDConfig(
            inputPath: testConfigPath,
            hostName: defaultHostName,
            modules: moduleRegistry.additionalModulesConfig,
            outputPath: self.patchedCLAIDConfigPath
        )
    }
    
    /// Initializes the Python interpreter and starts CLAID
    /// - Throws: CLAIDError if initialization fails
    public func start() throws {
        try setUpPythonDependencies()
        try patchCLAIDConfig()
        
        // Start asynchronous initialization.
        Task {
            await self.startCLAIDFramework()
        }
    }

        
    /// Default initializer for the CLAIDModule
    public init() {}
    
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
