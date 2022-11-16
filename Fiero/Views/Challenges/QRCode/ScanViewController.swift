//
//  ScanViewController.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 25/08/22.
//

import UIKit
import Vision
import AVFoundation
import Foundation
import SwiftUI

class ScanViewController: UIViewController {
    
    @Binding var text: String
    
    private lazy var cameraPreviewLayer: AVCaptureVideoPreviewLayer = {
        let l = AVCaptureVideoPreviewLayer(session: captureSession)
        l.videoGravity = .resizeAspectFill
        l.connection?.videoOrientation = .portrait
        return l
    }()
    
    private lazy var captureSession: AVCaptureSession = {
        let s = AVCaptureSession()
        s.sessionPreset = .hd1280x720
        return s
    }()
    
    private let process: ProcessQRCode
    private static var defaultPrintJSON: ProcessQRCode = { data in
        guard let jsonString = String(data: data, encoding: .utf8) else { return }
        print(jsonString)
    }

    init(process: ProcessQRCode? = defaultPrintJSON, text: Binding<String>) {
        self.process = process ?? ScanViewController.defaultPrintJSON
        self._text = text
        super.init(nibName: nil, bundle: nil)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupCameraLiveView()
    }

    override func viewDidLayoutSubviews() {
        cameraPreviewLayer.frame = view.bounds
        cameraPreviewLayer.connection?.videoOrientation = UIDevice.current.orientation.forVideoOrientation
    }
  
    private func checkCameraSettings(){
        if AVCaptureDevice.authorizationStatus(for: .video) !=  .authorized {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if !granted {
                    let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "BoardingAgent"
                    let cameraDisableAlert = UIAlertController(title: "Camera Disabled",
                                                                message: "Please enable Camera in \(bundleName) Settings.", preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
                        cameraDisableAlert.dismiss(animated: true, completion: nil)
                    }
                    cameraDisableAlert.addAction(cancelAction)

                    func settingsAction(action: UIAlertAction) {
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) { UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil) }
                        cameraDisableAlert.dismiss(animated: true)
                    }
                    
                    let goToSettingsAction = UIAlertAction(title: "Go to Settings", style: .default, handler: settingsAction)
                    cameraDisableAlert.addAction(goToSettingsAction)
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.present(cameraDisableAlert, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    private func setupCameraLiveView() {
        // MARK: Ensure Camera Settings Allowed
        #if !targetEnvironment(simulator)
        checkCameraSettings()
        #endif
        
        view.contentMode = .scaleAspectFit
        view.layer.masksToBounds = true
        view.layer.addSublayer(cameraPreviewLayer)
        cameraPreviewLayer.frame = view.bounds
        
        // Set up the video device.
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
                                                                      mediaType: AVMediaType.video,
                                                                      position: .back)
        
        // MARK: Get Back Camera
        guard let backCamera = deviceDiscoverySession.devices.first(where: { $0.position == .back }) else { return }
    
        // Set up the input and output stream.
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: backCamera)
            captureSession.addInput(captureDeviceInput)
        } catch {
            showAlert(withTitle: "Camera error", message: "Your camera can't be used as an input device.")
            return
        }
        
        let deviceOutput = AVCaptureVideoDataOutput()
        deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        
        // Set the quality of the video
        deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        
        // What we will display on the screen
        captureSession.addOutput(deviceOutput)
        
        // MARK: Start Camera
        captureSession.startRunning()
    }
    
    lazy var detectBarcodeRequest: VNDetectBarcodesRequest = {
        return VNDetectBarcodesRequest(completionHandler: { (request, error) in
            guard error == nil else { return }
            self.processClassification(for: request)
        })
    }()
    
    private func processClassification(for request: VNRequest) {
        DispatchQueue.main.async {
            if let bestResult = request.results?.first as? VNBarcodeObservation,
                let payload = bestResult.payloadStringValue {
                if bestResult.symbology == .QR {
                    guard let data = payload.data(using: .utf8) else { return }
                    self.process(data)
                    guard let jsonString = String(data: data, encoding: .utf8) else { return }
                    self.text = jsonString
                    // Here the logic stop capture because already read the QR Code
                    if self.captureSession.isRunning {
                        self.captureSession.stopRunning()
                    }
                }
            }
        }
    }
    
    public func startCamera() {
        self.captureSession.startRunning()
    }
    
    private func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

extension ScanViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        var requestOptions: [VNImageOption : Any] = [:]
        
        if let camData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
            requestOptions = [.cameraIntrinsics : camData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: requestOptions)
        try? imageRequestHandler.perform([self.detectBarcodeRequest])
    }
}

public typealias ProcessQRCode = (_ data: Data) -> ()
