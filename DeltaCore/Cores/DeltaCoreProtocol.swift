//
//  DeltaCoreProtocol.swift
//  DeltaCore
//
//  Created by Riley Testut on 6/29/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

import AVFoundation

public protocol DeltaCoreProtocol: CustomStringConvertible
{
    /* General */
    var name: String { get }
    var identifier: String { get }
    
    var gameType: GameType { get }
    var gameSaveFileExtension: String { get }
    
    // Should be associated type, but Swift type system makes this difficult, so ¯\_(ツ)_/¯
    var gameInputType: Input.Type { get }
    
    /* Rendering */
    var audioFormat: AVAudioFormat { get }
    var videoFormat: VideoFormat { get }
    
    /* Cheats */
    var supportedCheatFormats: Set<CheatFormat> { get }
    
    /* Emulation */
    var emulatorBridge: EmulatorBridging { get }
    
    var resourceBundle: Bundle { get }
}

public extension DeltaCoreProtocol
{
    var bundle: Bundle {
        #if FRAMEWORK
        let bundle = Bundle(for: type(of: self.emulatorBridge))
        #else
        let bundle = Bundle.main
        #endif
        return bundle
    }
    
    var resourceBundle: Bundle {
        #if FRAMEWORK
        let bundle = Bundle(for: type(of: self.emulatorBridge))
        #elseif STATIC_LIBRARY
        let bundle: Bundle
        if let bundleURL = Bundle.main.url(forResource: self.name, withExtension: "bundle")
        {
            bundle = Bundle(url: bundleURL)!
        }
        else
        {
            bundle = .main
        }
        #else
        let bundle = Bundle.main
        #endif
        
        return bundle
    }
}

public extension DeltaCoreProtocol
{
    var description: String {
        let description = "\(self.name) (\(self.identifier))"
        return self.name
    }
}

public func ==(lhs: DeltaCoreProtocol, rhs: DeltaCoreProtocol) -> Bool
{
    return lhs.identifier == rhs.identifier
}
