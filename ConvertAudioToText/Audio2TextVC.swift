//
//  ViewController.swift
//  ConvertAudioToText
//
//  Created by Banyar on 10/7/19.
//  Copyright © 2019 BNH. All rights reserved.
//

import UIKit
import Speech

import AVFoundation

class Audio2TextVC: UIViewController {

    @IBOutlet weak var scriptTextField: UITextView!
     var player: AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        setup()
    }
    
    func setup(){
       requestTranscribePermissions()
    }

    func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    print("Ready to go! 😍😍😍😍😍")
                } else {
                    print("Transcription permission was declined. 😭😭😭😭😭")
                }
            }
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "AudioText", withExtension: "m4a") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func convertAudioToScrip() {
        // create a new recognizer
        let recognizer = SFSpeechRecognizer()
        
        //Get Bundle Resource
        let bundleURL = Bundle.main.url(forResource: "AudioText", withExtension: "m4a")!
        
        // create a new Request
        let request = SFSpeechURLRecognitionRequest(url: bundleURL)
        
        
        recognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            guard let result = result else {
                print("There was an error: \(error!)")
                return
            }
            
            // if we wanna get only on every word of audio
            print("Result ", result.bestTranscription.formattedString)
            self.scriptTextField.text = result.bestTranscription.formattedString
            
            // if we wanna get only on final word of audio check the isFinal Condition
            if result.isFinal {
                print(result.bestTranscription.formattedString)
                self.scriptTextField.text = result.bestTranscription.formattedString
            }
        })
    }
    
    @IBAction func convertAudio2String(_ sender : UIButton){
        self.playSound()
        self.convertAudioToScrip()
    }
}

