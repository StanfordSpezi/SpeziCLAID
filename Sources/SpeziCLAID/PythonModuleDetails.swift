//
//  PythonModuleDetails.swift
//  SpeziCLAID
//
//  Created by Patrick Langer on 11.03.2025.
//

public struct PythonModuleDetails {
    public let pythonFilePath: String
    public let pythonModuleName: String
    
    public init(pythonFilePath: String, pythonModuleName: String) {
        self.pythonFilePath = pythonFilePath
        self.pythonModuleName = pythonModuleName
    }
}
