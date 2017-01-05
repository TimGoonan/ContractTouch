//
//  AudioScreen.swift
//  ContractTouch
//
//  Created by SDG1 on 9/13/16.
//  Copyright © 2016 GoonanCo. All rights reserved.
//

import UIKit
import AVFoundation

class AudioScreen: UIViewController, AudioRecorderViewControllerDelegate , AVAudioRecorderDelegate {
    
    var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func startRecord(_ sender: AnyObject) {
        let controller = AudioRecorderViewController()
        controller.audioRecorderDelegate = self
        present(controller, animated: true, completion: nil)
    }
    
    func audioRecorderViewControllerDismissed(withFileURL fileURL: URL?) {
        // do something with fileURL
        dismiss(animated: true, completion: nil)
    }
}
