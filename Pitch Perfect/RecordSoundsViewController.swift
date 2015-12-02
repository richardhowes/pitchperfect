//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Richard Howes on 2015/12/01.
//  Copyright © 2015 workflow. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var recordingPaused = false
    var filePath:NSURL!

    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var pauseRecordingButton: UIButton!
    @IBOutlet var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    @IBAction func recordAudio(sender: AnyObject) {
        // If we are not recording, start recording and set label
        self.recordingLabel.text = "Recording in Progress..."

        stopRecordingButton.hidden = false
        pauseRecordingButton.hidden = false
        pauseRecordingButton.enabled = true
        recordButton.enabled = false

        audioRecorder.record()
    }
    
    // This function does the necessary setup before the segue is called
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // If we are seguing to "stopRecording" which our effects view
        if (segue.identifier == "stopRecording"){
            // Create constant that links to the destination view controlled
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            // Create constand that has the audio from the object that called the segue (in this case the audio object
            let data = sender as! RecordedAudio
            
            // Pass the sound data to the destination view controller
            playSoundsVC.receivedAudio = data
            
        }
    }
    
    // This is a delagated function that is called when recording is finished and then processes
    // the segue to open the effects view controller
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            // Initialise recordedAudio var with title and path to file
            recordedAudio = RecordedAudio(pathParm: recorder.url, titleParm: recorder.url.lastPathComponent!)
        
            // Perform segue to audio effects view
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
    
    // Stop recording
    @IBAction func stopRecording(sender: AnyObject) {
        // Hide the stop recording button
        self.stopRecordingButton.hidden = true
        
        // Re-enable the record button
        recordButton.enabled = true
        
        // Stop the recording
        audioRecorder.stop()
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        // Pause the recording
        audioRecorder.pause()
        pauseRecordingButton.enabled = false
        self.recordingLabel.text = "Recording Paused..."
        recordButton.enabled = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        // Setup the file for recording
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        filePath = NSURL.fileURLWithPathComponents(pathArray)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        // Hide stop and pause buttons
        stopRecordingButton.hidden = true
        pauseRecordingButton.hidden = true
        recordingLabel.text = "Tap to Record..."
    }

}

