//
//  PhotoMissionView.swift
//  SnapWake
//
//  Vue caméra pour missions photo avec IA
//

import SwiftUI
import AVFoundation

struct PhotoMissionView: View {
    @Environment(\.colorScheme) var colorScheme

    let mission: Mission
    let huntObject: HuntObject?
    let onComplete: (Bool) -> Void

    @StateObject private var cameraManager = CameraManager()
    @State private var isVerifying = false
    @State private var verificationResult: String?

    var cameraType: CameraType {
        switch mission.name {
        case "Sky Photo": return .back
        case "Make Bed": return .back
        case "Object Hunt": return .back
        case "Touch Grass": return .back
        default: return .back
        }
    }

    var instructionText: String {
        switch mission.name {
        case "Sky Photo": return "Point camera at the sky"
        case "Make Bed": return "Show your made bed"
        case "Object Hunt":
            if let obj = huntObject {
                return "Find: \(obj.emoji) \(obj.name)"
            }
            return "Find the object"
        case "Touch Grass": return "Take photo of grass"
        default: return "Take a photo"
        }
    }

    var body: some View {
        ZStack {
            // Camera Preview
            CameraPreviewView(cameraManager: cameraManager)
                .ignoresSafeArea()
                .onAppear {
                    cameraManager.startSession(cameraType: cameraType)
                }
                .onDisappear {
                    cameraManager.stopSession()
                }

            VStack(spacing: 0) {
                // Top instruction - clean design
                VStack(spacing: 16) {
                    Text(instructionText)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 4)

                    if let huntObject = huntObject {
                        HStack(spacing: 8) {
                            Text(huntObject.emoji)
                                .font(.system(size: 24))
                            Text(huntObject.name)
                                .font(.system(size: 18, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(25)
                    }
                }
                .padding(.top, 70)

                Spacer()

                // Frame corners
                ZStack {
                    // Corners
                    VStack {
                        HStack {
                            FrameCorner(corners: [.topLeft])
                            Spacer()
                            FrameCorner(corners: [.topRight])
                        }
                        Spacer()
                        HStack {
                            FrameCorner(corners: [.bottomLeft])
                            Spacer()
                            FrameCorner(corners: [.bottomRight])
                        }
                    }
                    .padding(40)
                    .frame(height: 450)

                    // Verification status in center
                    if isVerifying {
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(.white)

                            Text("AI is verifying...")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.black.opacity(0.75))
                                .shadow(color: .black.opacity(0.3), radius: 10)
                        )
                    } else if let result = verificationResult {
                        HStack(spacing: 12) {
                            Image(systemName: result.contains("✅") ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(result.contains("✅") ? .green : .red)

                            Text(result.replacingOccurrences(of: "✅ ", with: "").replacingOccurrences(of: "❌ ", with: ""))
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.black.opacity(0.75))
                                .shadow(color: .black.opacity(0.3), radius: 10)
                        )
                    }
                }

                Spacer()

                // Bottom hint
                Text(getBottomHint())
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(25)
                    .shadow(color: .black.opacity(0.2), radius: 8)
                    .padding(.bottom, 12)

                // Branding
                MissionBrandingView()
                    .padding(.bottom, 20)

                // Capture button - clean design
                Button(action: capturePhoto) {
                    ZStack {
                        Circle()
                            .stroke(Color.white, lineWidth: 5)
                            .frame(width: 80, height: 80)

                        Circle()
                            .fill(Color.white)
                            .frame(width: 65, height: 65)
                    }
                }
                .disabled(isVerifying || !cameraManager.isSessionRunning)
                .opacity((isVerifying || !cameraManager.isSessionRunning) ? 0.5 : 1.0)
                .padding(.bottom, 50)
            }
        }
    }

    private func getBottomHint() -> String {
        switch mission.name {
        case "Sky Photo": return "Point at the sky and capture"
        case "Make Bed": return "Frame your made bed"
        case "Object Hunt":
            if let obj = huntObject {
                return "Find your \(obj.name) and frame it"
            }
            return "Find and frame the object"
        case "Touch Grass": return "Capture grass in frame"
        default: return "Tap to capture"
        }
    }

    private func capturePhoto() {
        cameraManager.capturePhoto { image in
            guard let image = image else {
                verificationResult = "❌ Failed to capture"
                return
            }

            // Start AI verification
            isVerifying = true
            AIVerificationService.shared.verifyPhoto(
                image: image,
                mission: mission,
                targetObject: huntObject?.name
            ) { success, message in
                isVerifying = false

                if success {
                    verificationResult = "✅ \(message)"
                    // Attendre 1 seconde puis compléter
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        onComplete(true)
                    }
                } else {
                    verificationResult = "❌ \(message)"
                    // Reset après 2 secondes
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        verificationResult = nil
                    }
                }
            }
        }
    }
}

// MARK: - Camera Preview
struct CameraPreviewView: UIViewRepresentable {
    @ObservedObject var cameraManager: CameraManager

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .black

        if let previewLayer = cameraManager.previewLayer {
            previewLayer.frame = UIScreen.main.bounds
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = cameraManager.previewLayer {
            DispatchQueue.main.async {
                previewLayer.frame = uiView.bounds
            }
        }
    }
}

// MARK: - Camera Manager
enum CameraType {
    case front, back
}

class CameraManager: NSObject, ObservableObject {
    private let session = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()
    private var videoOutput = AVCaptureVideoDataOutput()
    private var currentCamera: AVCaptureDevice?
    private var photoCaptureCompletion: ((UIImage?) -> Void)?
    @Published var isSessionRunning = false

    var previewLayer: AVCaptureVideoPreviewLayer?
    var frameCallback: ((CMSampleBuffer) -> Void)?

    override init() {
        super.init()
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
    }

    func startSession(cameraType: CameraType) {
        Task {
            await requestCameraPermission()
            setupCamera(cameraType: cameraType)

            // Start session on background queue
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.session.startRunning()

                // Wait a bit for session to stabilize
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.isSessionRunning = true
                }
            }
        }
    }

    func stopSession() {
        session.stopRunning()
        isSessionRunning = false
    }

    private func requestCameraPermission() async {
        await AVCaptureDevice.requestAccess(for: .video)
    }

    private func setupCamera(cameraType: CameraType) {
        session.beginConfiguration()

        // Remove existing inputs and outputs
        session.inputs.forEach { session.removeInput($0) }
        session.outputs.forEach { session.removeOutput($0) }

        // Add camera input
        let position: AVCaptureDevice.Position = cameraType == .front ? .front : .back
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            session.commitConfiguration()
            return
        }

        if session.canAddInput(input) {
            session.addInput(input)
            currentCamera = camera
        }

        // Add photo output
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }

        // Add video output for frame-by-frame analysis (for pose detection)
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }

        session.commitConfiguration()
    }

    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        photoCaptureCompletion = completion

        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            photoCaptureCompletion?(nil)
            return
        }

        photoCaptureCompletion?(image)
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Send frame to callback for pose detection
        frameCallback?(sampleBuffer)
    }
}
