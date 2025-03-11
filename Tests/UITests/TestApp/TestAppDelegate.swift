//
//  TestAppDelegate.swift
//  SpeziCLAID
//
//  Created by Patrick Langer on 10.03.2025.
//


import Spezi
import SpeziCLAID


class TestAppDelegate: SpeziAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: ExampleStandard()) {
            CLAIDModule()
        }
    }
}
