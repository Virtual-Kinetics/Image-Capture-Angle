//
//  CameraView.swift
//  GoniometerAlpha
//
//  Created by Keshav Patel on 9/11/16.
//  Copyright © 2016 Keshav Patel. All rights reserved.
//

import UIKit
import AVFoundation

class CameraView: UIView
{

    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        // All the devices that the phone is capable of using
        let devices = AVCaptureDevice.devices()
        
        // Loop through all the capture devices on this phone
        for device in devices
        {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo))
            {
                // Finally check the position and confirm we've got the back camera
                if(device.position == AVCaptureDevicePosition.Back)
                {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil
                    {
                        beginSession()
                    }
                }
            }
        }
    }
    

    func beginSession()
    {
        
        let err : NSError? = nil
        let x = try? AVCaptureDeviceInput(device: captureDevice)
        // Adding AVCaptureDevice as our camera input
        captureSession.addInput(x!)
        
        if err != nil
        {
            print("error: \(err?.localizedDescription)")
        }
        
        // Specifying that the output image is in JPEG format
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        captureSession.addOutput(stillImageOutput)
        
        // The layer that shows what the camera sees
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        // adding layer to view, but buttons must be on top to be seen
        layer.insertSublayer(previewLayer!, below: nil)
        previewLayer?.frame = frame
        captureSession.startRunning()
    }
    
    func endSession()
    {
        captureSession.stopRunning()
    }
    
    func resumeSession()
    {
        captureSession.startRunning()
    }
}
