//
//  TestMod.swift
//  UITests
//
//  Created by Patrick Langer on 25.02.2025.
//

import CLAID
actor TestMod: Module {
    public var moduleHandle = ModuleHandle()
    private var outputChannel: Channel<Int>? = nil
    private var ctr = 0
    func initialize(properties: Properties) async throws {
        self.outputChannel = try await self.publish("OutputChannel", dataTypeExample: Int(42))
        
        await self.registerPeriodicFunction(name: "TestFunction", interval: .seconds(1), function: self.send_data)
    }
    
    func send_data() async {
        print("TestFunction called")
        await self.outputChannel?.post(ctr)
        ctr += 1
    }
    
    func terminate() async {
        
    }
    
    
}
