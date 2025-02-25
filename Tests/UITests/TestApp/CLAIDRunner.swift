//
//  CLAIDRunner.swift
//  UITests
//
//  Created by Patrick Langer on 25.02.2025.
//

import CLAID
actor CLAIDRunner {
    
    private var running = false
    
    init(configFile: String, host: String, user: String, device: String, moduleFactoryRegisration: @escaping () async -> ModuleFactory) {
        Task {
            await asyncInit(configFile: configFile, host: host, user: user, device: device, moduleFactoryRegisration: moduleFactoryRegisration)
        }
    }
    
    func asyncInit(configFile: String, host: String, user: String, device: String, moduleFactoryRegisration: @escaping  () async -> ModuleFactory) async {
        do {
            if(running) {
                return
            }
            
            let moduleFactory: ModuleFactory = await moduleFactoryRegisration()
                
            try await CLAID.start(
                configFile: configFile,
                hostID: host,
                userID: user,
                deviceID: device,
                moduleFactory: moduleFactory
            )
            
            running = true
        } catch {
            Logger.logFatal("Failed to initialize CLAID")
        }
    }
}
