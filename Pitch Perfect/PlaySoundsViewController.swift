//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Richard Howes on 2015/12/01.
//  Copyright © 2015 workflow. All rights reserved.
//

import UIKit
import AVFoundation

// Create an AVAudioEngine variable
var audioEngine: AVAudioEngine!


class PlaySoundsViewController: UIViewController {

    // Variable to store the passed audio file
    var receivedAudio:RecordedAudio!
    
    // Vars to store the audio file & player node
    var audioFile:AVAudioFile!
    var audioPlayerNode: AVAudioPlayerNode!
    
    // The next four functions are attached to the four buttons and
    // call the function to add the audio effect
    @IBAction func darthvaderPlay(sender: UIButton) {
        playAudioWithEffect("pitch", audioValue: -1000)
    }
    
    @IBAction func chipmunkPlay(sender: AnyObject) {
        playAudioWithEffect("pitch", audioValue: 1000)
    }
    
    @IBAction func slowPLay(sender: AnyObject) {
        playAudioWithEffect("speed", audioValue: 0.5)
    }
    
    @IBAction func fastPlay(sender: AnyObject) {
        playAudioWithEffect("speed", audioValue: 2)
    }
    
    @IBAction func echoPlay(sender: UIButton) {
        playAudioWithEffect("echo", audioValue: 0.5)
    }
    
    @IBAction func reverbPlay(sender: UIButton) {
        playAudioWithEffect("reverb", audioValue: 50)
    }

    // Stop the playback
    @IBAction func stopPlay(sender: AnyObject) {
        audioPlayerNode.stop()
    }
    
    // Common function to implement the audio effects
    // Takes two variables, the effect requested and the effect value
    func playAudioWithEffect(audioEffect: String, audioValue: Float)
    {
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        
        // Change effect based on value passed
        // TODO: Could not move the audioEngine code out of the switch statement as I could not
        // work out how to get the changeEffect constant to be availabe out of the switch scope
        // and since it needs to be one of three different objects.
        // There must be a way to refactor this to prevent the duplicated code but I could not
        // figure out how.
        switch audioEffect {
            case "pitch":
                let changeEffect = AVAudioUnitTimePitch()
                changeEffect.pitch = audioValue
                audioEngine.attachNode(changeEffect)
                audioEngine.connect(audioPlayerNode, to: changeEffect, format: nil)
                audioEngine.connect(changeEffect, to: audioEngine.outputNode, format: nil)
                break
            
            case "speed":
                let changeEffect = AVAudioUnitTimePitch()
                changeEffect.rate = audioValue
                audioEngine.attachNode(changeEffect)
                audioEngine.connect(audioPlayerNode, to: changeEffect, format: nil)
                audioEngine.connect(changeEffect, to: audioEngine.outputNode, format: nil)
                break
            
            case "echo":
                let changeEffect = AVAudioUnitDelay()
                let audioValueDouble:Double = Double(audioValue)
                changeEffect.delayTime = audioValueDouble
                audioEngine.attachNode(changeEffect)
                audioEngine.connect(audioPlayerNode, to: changeEffect, format: nil)
                audioEngine.connect(changeEffect, to: audioEngine.outputNode, format: nil)
                break

            case "reverb":
                let changeEffect = AVAudioUnitReverb()
                changeEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
                changeEffect.wetDryMix = audioValue
                audioEngine.attachNode(changeEffect)
                audioEngine.connect(audioPlayerNode, to: changeEffect, format: nil)
                audioEngine.connect(changeEffect, to: audioEngine.outputNode, format: nil)
                print("reverb")
                break
            
            default:
                //TODO: Handle Error
                break
        }
        
        // Attached and connect the neccesary components and initialise
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        // Play the audio file
        audioPlayerNode.play()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialise the audio engine and try reading the file
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
