//
//  Audio.swift
//  LanguageGame
//
//  Created by Ana Calvo on 30/10/18.
//  Copyright © 2018 Ana Calvo. All rights reserved.
//

import Foundation
import AVFoundation

class Audio {
    var audioPlayer = AVAudioPlayer()
    
    func playFileFromUrl(resource: String) {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "\(resource)", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.prepareToPlay()
        } catch {
            print("Problem in getting sound file")
        }
        audioPlayer.play()
    }
}
