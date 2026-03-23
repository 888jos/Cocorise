//
//  CameraService.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI
import AVFoundation
import UIKit

class CameraService: NSObject, ObservableObject {
    @Published var capturedImage: UIImage?
    @Published var isAuthorized = false

    private var captureSession: AVCaptureSession?
    private var photoOutput: AVCapturePhotoOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?

    override init() {
        super.init()
        checkAuthorization()
    }

    func checkAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isAuthorized = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.isAuthorized = granted
                }
            }
        default:
            isAuthorized = false
        }
    }

    func setupCamera(for layer: CALayer) {
        guard isAuthorized else { return }

        let session = AVCaptureSession()
        session.beginConfiguration()

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return
        }

        if session.canAddInput(input) {
            session.addInput(input)
        }

        let output = AVCapturePhotoOutput()
        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        session.commitConfiguration()

        self.captureSession = session
        self.photoOutput = output

        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.frame = layer.bounds
        preview.videoGravity = .resizeAspectFill
        layer.addSublayer(preview)
        self.previewLayer = preview

        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
    }

    func capturePhoto() {
        guard let photoOutput = photoOutput else { return }

        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    func stopCamera() {
        captureSession?.stopRunning()
    }
}

extension CameraService: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            return
        }

        DispatchQueue.main.async {
            self.capturedImage = image
        }
    }
}

// SwiftUI wrapper
struct CameraView: UIViewRepresentable {
    let cameraService: CameraService

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        DispatchQueue.main.async {
            cameraService.setupCamera(for: view.layer)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
