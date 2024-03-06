//
//  AboutViewControllerSnapshot.swift
//  BeerMaisTests
//
//  Created by José Neves on 25/12/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation
import XCTest

import SnapshotTesting

class AboutViewControllerSnapshot: XCTestCase {
    
    override class func setUp() {
        isRecording = false
    }

    func testViewController() {
        let remoteConfig = RemoteConfigSpy()
        
        let remoteConfigValueStub = RemoteConfigValueStub()
        remoteConfigValueStub.boolValue = false
        
        remoteConfig.configValueCacheReturn = ["is_donate_available": remoteConfigValueStub]
        
        let vc = AboutFactory.build(remoteConfig: remoteConfig)

        assertSnapshot(of: vc, as: .image)
    }

    func testWithDonatesViewController() {
        let remoteConfig = RemoteConfigSpy()
        
        let remoteConfigValueStub = RemoteConfigValueStub()
        remoteConfigValueStub.boolValue = true
        
        remoteConfig.configValueCacheReturn = ["is_donate_available": remoteConfigValueStub]
        
        let vc = AboutFactory.build(remoteConfig: remoteConfig)

        assertSnapshot(of: vc, as: .image)
    }
}
