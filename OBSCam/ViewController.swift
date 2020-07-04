//
//  ViewController.swift
//  OBSCam
//
//  Created by Davide Toldo on 04.07.20.
//  Copyright © 2020 Davide Toldo. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var captureSession = AVCaptureSession()
    var photoOutput = AVCapturePhotoOutput()
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var cameras = [AVCaptureDevice]()
    var currentCamera: Int?

    lazy var doubleTapRecognizer: UITapGestureRecognizer = {
        let utgr = UITapGestureRecognizer()
        utgr.numberOfTapsRequired = 2
        utgr.delegate = self
        utgr.addTarget(self, action: #selector(switchCamera))
        return utgr
    }()
    
    lazy var singleTapRecognizer: UITapGestureRecognizer = {
        let utgr = UITapGestureRecognizer()
        utgr.numberOfTapsRequired = 1
        utgr.delegate = self
        utgr.require(toFail: doubleTapRecognizer)
        utgr.addTarget(self, action: #selector(toggleControls))
        return utgr
    }()
    
    let noCameraLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .center
        view.text = "Please consent camera access via Settings to allow this App to work correctly."
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomBar: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.effect = UIBlurEffect(style: .systemUltraThinMaterial)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var helpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Help", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        button.setTitleColor(.systemGreen, for: .normal)
        button.addTarget(self, action: #selector(help), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.setTitle("Switch Camera", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        button.setTitleColor(.systemGreen, for: .normal)
        button.addTarget(self, action: #selector(switchCamera), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func defaultCamera() -> AVCaptureDevice? {
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
            for: AVMediaType.video, position: .back) {
            return device
        }
        else if let device = AVCaptureDevice.default(.builtInTelephotoCamera,
            for: AVMediaType.video, position: .back) {
            return device
        }
        else if let device = AVCaptureDevice.default(.builtInUltraWideCamera,
            for: AVMediaType.video, position: .back) {
            return device
        }
        else {
            return nil
        }
    }

    override func viewDidLoad() {
        // view setup
        super.viewDidLoad()
        view.addGestureRecognizer(doubleTapRecognizer)
        view.addGestureRecognizer(singleTapRecognizer)
        view.addSubview(bottomBar)
        view.addSubview(helpButton)
        view.addSubview(cameraButton)
        view.addSubview(noCameraLabel)
        
        let constraints = [
            bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -1*UITabBar.height),
            
            helpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            helpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            
            cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cameraButton.leadingAnchor.constraint(greaterThanOrEqualTo: helpButton.trailingAnchor, constant: 25),
            cameraButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            
            noCameraLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noCameraLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noCameraLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            noCameraLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        // capture  session
        captureSession.sessionPreset = .high
        
        // device discovery
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera,
            for: AVMediaType.video, position: .back) {
            cameras.append(device)
        }
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
            for: AVMediaType.video, position: .back) {
            cameras.append(device)
        }
        if let device = AVCaptureDevice.default(.builtInTelephotoCamera,
            for: AVMediaType.video, position: .back) {
            cameras.append(device)
        }
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
            for: AVMediaType.video, position: .front) {
            cameras.append(device)
        }
        
        currentCamera = cameras.count > 0 ? 0 : nil
        
        guard let camera = currentCamera,
        let captureDeviceInput = try? AVCaptureDeviceInput(device: cameras[camera])
        else { return }
        
        if captureSession.canAddInput(captureDeviceInput) {
            captureSession.addInput(captureDeviceInput)
        }
        
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = .resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = .portrait
        cameraPreviewLayer?.frame = view.bounds
        guard let cpl = cameraPreviewLayer else { print("Error: camera preview layer is nil."); return }
        view.layer.insertSublayer(cpl, at: 0)

        if !captureSession.isRunning {
            captureSession.startRunning()
        }
        
        noCameraLabel.isHidden = true
    }

    @objc func switchCamera() {
        currentCamera = currentCamera != nil ? (currentCamera!+1)%cameras.count : nil
        resetCaptureSession()
    }
    
    @objc func toggleControls() {
        UIView.animate(withDuration: 0.5) {
            self.bottomBar.alpha = abs(self.bottomBar.alpha-1)
            self.helpButton.alpha = abs(self.helpButton.alpha-1)
            self.cameraButton.alpha = abs(self.cameraButton.alpha-1)
        }
    }
    
    @objc func help() {
        let controller = TutorialController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        present(controller, animated: true, completion: nil)
    }

    private func resetCaptureSession() {
        guard let currentCamera = currentCamera else { return }
        
        captureSession.beginConfiguration()
        captureSession.inputs.forEach { captureSession.removeInput($0) }

        let cameraInput: AVCaptureDeviceInput
        do {
            cameraInput = try AVCaptureDeviceInput(device: cameras[currentCamera])
        }
        catch {
            print(error)
            return
        }

        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
        }

        captureSession.commitConfiguration()
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
