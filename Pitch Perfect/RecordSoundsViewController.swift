//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jared Zenk on 04/24/15.
//  Copyright (c) 2015 Jared Zenk. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var paused: Bool! //determines if audio recording has been paused or not

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        paused = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // action associated with press of microphone button
    @IBAction func recordAudio(sender: UIButton) {
        recordingInProgress.text = "Recording..."
        stopButton.hidden = false
        pauseButton.hidden = false
        recordButton.enabled = false
        
        if !paused {
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
            var currentDateTime = NSDate()
            var formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            var recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            var pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
            //setup audio session
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
            //initialize and prepare recorder
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
        }
        
        audioRecorder.record()
    }
    
    @IBAction func pauseRecording(sender: AnyObject) {
        audioRecorder.pause()

        recordingInProgress.text = "Tap to Resume"
        pauseButton.hidden = true
        recordButton.enabled = true
        paused = true
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.enabled = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        recordingInProgress.text = "Tap to Record"
        stopButton.hidden = true
        pauseButton.hidden = true
        recordButton.enabled = true
        paused = false
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

