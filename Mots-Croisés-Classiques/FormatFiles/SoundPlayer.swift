//
//  SoundPlayer.swift
//  IrregularVerbsTest
//
//  Created by Normand Martin on 2019-04-23.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import Foundation
import AVFoundation
class SoundPlayer {
    var player: AVAudioPlayer?
    func playSound(soundName: String, type: String) {
        let path = Bundle.main.path(forResource: soundName, ofType: type)!
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("couldn't load file :(")
        }
    }
    func stopSound() {
        player?.stop()
    }
    
}
