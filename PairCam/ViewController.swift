//
//  ViewController.swift
//  PairCam
//
//  Created by Mark DeLillo on 8/15/18.
//  Copyright © 2018 Mark DeLillo. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {
    @IBOutlet weak var camView1: NSView!
    @IBOutlet weak var camView2: NSView!
    @IBOutlet weak var camSelector1: NSPopUpButton!
    @IBOutlet weak var camSelector2: NSPopUpButton!
    
    let session1 = AVCaptureSession()
    let session2 = AVCaptureSession()
    var devices: [AVCaptureDevice]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        populateCamNames()
        startSession(session: session1, view: camView1)
        startSession(session: session2, view: camView2)
    }
    
    @IBAction func selectCam1(_ sender: Any) {
        setInput(session: session1, deviceName: camSelector1.selectedItem?.title)
    }
    
    @IBAction func selectCam2(_ sender: Any) {
        setInput(session: session2, deviceName: camSelector2.selectedItem?.title)
    }
    
    func populateCamNames() {
        devices = AVCaptureDevice.devices(for: AVMediaType.video)
        let deviceNames = devices!.map { device in device.localizedName }
        camSelector1.addItems(withTitles: deviceNames)
        camSelector2.addItems(withTitles: deviceNames)
    }
    
    func startSession(session:AVCaptureSession, view:NSView) {
        view.wantsLayer = true
        session.sessionPreset = AVCaptureSession.Preset.low
        let previewLayer:AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer?.addSublayer(previewLayer)
        setInput(session: session)
        session.startRunning()
    }
    
    func setInput(session:AVCaptureSession, deviceName:String? = "") {
        var device:AVCaptureDevice
        if deviceName == "" {
            device = AVCaptureDevice.default(for: AVMediaType.video)!
        } else {
            device = devices!.first { (d) -> Bool in
                d.localizedName == deviceName
            }!
        }
        let deviceInput : AVCaptureDeviceInput = try! AVCaptureDeviceInput(device: device)
        
        for existingInput in session.inputs {
            session.removeInput(existingInput)
        }
        if session.canAddInput(deviceInput) {
            session.addInput(deviceInput)
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

