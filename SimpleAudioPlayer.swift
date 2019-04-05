//
//  SimpleAudioPlayer.swift
//
//  Created by Noah Tsutsui on 4/4/19.
//  Copyright © 2019 TwoButts. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isEnabled = false
        pauseButton.isEnabled = false
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        } catch {
            print("🤔 Couldn't get audio session", error)
        }
        
        do {
            let soundFileReference = Bundle.main.path(forResource: "50", ofType: "m4a")
            if let ref = soundFileReference {
                self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: ref))
                guard let player = self.audioPlayer else { return }
                player.delegate = self
                player.prepareToPlay()
                print("👍 Created audioPlayer obj!")
            }
        } catch {
            print("🤔 Couldn't create audioPlayer obj:", error)
        }
    }
    
    @IBAction func didTapPlayButton(_ sender: Any) {
        guard let audioPlayer = audioPlayer else {
            print("🤔 Couldn't unwrap player on play.")
            return
        }
        let isPlaying = audioPlayer.play()
        stopButton.isEnabled = isPlaying
        pauseButton.isEnabled = isPlaying
        playButton.isEnabled = !isPlaying
        if isPlaying {
            print("▶️ Audio started playing!")
        }
    }
    
    @IBAction func didTapStopButton(_ sender: Any) {
        guard let audioPlayer = audioPlayer else {
            print("🤔 Couldn't unwrap player on stop.")
            return
        }
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayerDidFinishPlaying(audioPlayer, successfully: true)
    }
    
    @IBAction func didTapPauseButton(_ sender: Any) {
        guard let audioPlayer = audioPlayer else {
            print("🤔 Couldn't unwrap player on pause.")
            return
        }
        if audioPlayer.isPlaying {
            audioPlayer.stop()
            audioPlayerDidFinishPlaying(audioPlayer, successfully: false)
        } else if !audioPlayer.isPlaying {
            audioPlayer.play()
            print("⏯ Audio resumed!")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let finishedPlaying = flag
        if finishedPlaying {
            stopButton.isEnabled = false
            pauseButton.isEnabled = false
            playButton.isEnabled = true
            print("⏹ Audio finished")
        } else if !finishedPlaying {
            stopButton.isEnabled = false
            pauseButton.isEnabled = true
            pauseButton.setTitle("Resume", for: .normal)
            playButton.isEnabled = true
            print("⏸ Audio paused")
        }
        
        
    }
    
}

