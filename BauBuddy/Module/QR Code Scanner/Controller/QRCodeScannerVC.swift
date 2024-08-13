//
//  QRCodeScannerVC.swift
//  BauBuddy
//
//  Created by cihangirincaz on 11.08.2024.
//

import UIKit
import AVFoundation

class QRCodeScannerVC: UIViewController {

    // MARK: Properties
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if captureSession?.isRunning == false {
            captureSession.startRunning()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }

    // MARK: Helpers
    private func setupCamera() {
        view.backgroundColor = .black
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                return
            }
        } catch {
            return
        }
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return
        }
        setupPreviewLayer()
        DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
    }
    func setupUI(){
        let topView = UIView()
        topView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.16)
        }
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.20)
        }
        let crossButton = UIButton()
        crossButton.setImage(.crossButton, for: .normal)
        crossButton.tintColor = .white
        crossButton.addTarget(self, action: #selector(crossButtonClicked), for: .touchUpInside)
        topView.addSubview(crossButton)
        crossButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.height.width.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        let QRScanImageView = UIImageView()
        QRScanImageView.image = .qrScan.withRenderingMode(.alwaysTemplate)
        QRScanImageView.tintColor = .black
        QRScanImageView.contentMode = .scaleAspectFit
        view.addSubview(QRScanImageView)
        QRScanImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(view.frame.width)
        }
    }
    private func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
    
    // MARK: - UI Settings
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    //MARK: Actions
    @objc func crossButtonClicked(){
        self.hero.modalAnimationType = .slide(direction: .down)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension QRCodeScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    func found(code: String) {
        print("Found QR code: \(code)")
        Globals.shared.qrQuerry = code
        dismiss(animated: true)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        dismiss(animated: true)
    }
}

