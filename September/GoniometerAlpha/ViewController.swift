//
//  ViewController.swift
//  Goniometer Beta
//
//  Created by Keshav Patel on 5/24/16.
//  Copyright © 2016 Keshav Patel. All rights reserved.
//

import UIKit
import AVFoundation

extension UIView
{
    func layerGradient()
    {
        let layer : CAGradientLayer = CAGradientLayer()
        layer.frame.size = self.frame.size
        layer.frame.origin = CGPointMake(0.0,0.0)
        layer.cornerRadius = CGFloat(frame.width / 20)
        
        let color0 = UIColor(red:250.0/255, green:250.0/255, blue:250.0/255, alpha:0.5).CGColor
        let color1 = UIColor(red:200.0/255, green:200.0/255, blue: 200.0/255, alpha:0.1).CGColor
        let color2 = UIColor(red:150.0/255, green:150.0/255, blue: 150.0/255, alpha:0.1).CGColor
        let color3 = UIColor(red:100.0/255, green:100.0/255, blue: 100.0/255, alpha:0.1).CGColor
        let color4 = UIColor(red:50.0/255, green:50.0/255, blue:50.0/255, alpha:0.1).CGColor
        let color5 = UIColor(red:0.0/255, green:0.0/255, blue:0.0/255, alpha:0.1).CGColor
        let color6 = UIColor(red:150.0/255, green:150.0/255, blue:150.0/255, alpha:0.1).CGColor
        
        layer.colors = [color0,color1,color2,color3,color4,color5,color6]
        self.layer.insertSublayer(layer, atIndex: 0)
    }
}

class ViewController: UIViewController
{
    
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var previewLayer : AVCaptureVideoPreviewLayer?
    //@IBOutlet var photoButton: UIButton!
    @IBOutlet var captureImage: UIButton!
    @IBOutlet var home: UIButton!
    //@IBOutlet var imageView: UIView!
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    
    var imageCapture : UIImage!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        // All the devices that the phone is capable of using
        let devices = AVCaptureDevice.devices()
        
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        beginSession()
                    }
                }
            }
        }
        /*
        let image = UIImage(named: "home") as UIImage?
        //home = UIButton(type: UIButtonType.Custom) as UIButton
        home.setImage(image, forState: .Normal)
        home.frame = CGRectMake(30, 30, 50, 50)
        view.addSubview(home)
        
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPointZero, size: self.captureImage.frame.size)
        gradient.colors = [UIColor.whiteColor().colorWithAlphaComponent(0.1).CGColor, UIColor.blackColor().colorWithAlphaComponent(0.1).CGColor]
        
        let shape = CAShapeLayer()
        shape.lineWidth = 0.1
        shape.path = UIBezierPath(ovalInRect: self.captureImage.bounds).CGPath
        shape.strokeColor = UIColor.blackColor().CGColor
        shape.fillColor = UIColor.greenColor().CGColor
        gradient.mask = shape
        
        captureImage.layer.addSublayer(gradient)
        view.addSubview(captureImage)
        */
        
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
        view.layer.insertSublayer(previewLayer!, below: home.layer)
        previewLayer?.frame = view.frame
        captureSession.startRunning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        if segue.identifier == "showImageView"
        {
            // Specify what type of output this will receive
            if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo)
            {
                stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
                    (sampleBuffer, error) in
                    // These slowly convert the raw data into the image we want
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    
                    self.imageCapture = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    
                    //Save the captured preview to image
                    //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    
                    // Allows the two Controllers to "talk" to each other
                    let destViewController: ImageController = segue.destinationViewController as! ImageController
                    destViewController.photo = self.imageCapture!
                    destViewController.viewDidLoad()
                })
            }
            
        }
 
        
    }
 
}

