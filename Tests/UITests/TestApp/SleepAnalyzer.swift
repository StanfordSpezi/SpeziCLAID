//
//  SleepAnalyzer.swift
//  UITests
//
//  Created by Patrick Langer on 14.03.2025.
//

import SpeziCLAID

import CLAID

final actor SleepAnalyzer : SpeziCLAIDModule {
    
    init() {
    }

    var moduleHandle = ModuleHandle()
    var analyze_function = RemoteFunction<SpeziClaid_SleepData, Int>()
 
    @MainActor
    func configure() {
        print("SleepAnalyzer configure")
        //claidDependency.addPythonModule(pythonFilePath: "", pythonClass: "", moduleConfig: Claidservice_ModuleConfig())
    }
    
    func initialize(properties: Properties) async throws {
        await moduleInfo("SleepAnalyzer initialize")
        
        analyze_function = try await self.mapRemoteFunctionOfModule(
            moduleId: "SleepDataAggregator",
            functionName: "analyze_sleep_data",
            returnType: SpeziClaid_SleepData(),
            parameterTypes: Int()
        )
        
        await registerScheduledFunction(name: "Analyze", after: Duration.seconds(2), function: self.analyzeData)
        
    }
    
    @Sendable
    func analyzeData() async {
        print("Analyze data called")
        do {
            guard let result: SpeziClaid_SleepData = try await self.analyze_function(42) else {
                print("Result is null.")
                return
            }
            print("Result: \(result.sleepSamples.value)")
           
        } catch {
            print("Error \(error)")
        }
    }
    
    func terminate() async {
        
    }
    

    
}
