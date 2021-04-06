import UIKit
import Vision
import AVFoundation

protocol HandDetectionViewDelegate : class {
    func detected(hand : Hand) -> ()
}

final class HandDetectionView : UIView {
    
    private let handRequest : VNDetectHumanHandPoseRequest = {
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = 1
        return request
    }()
    
    private let outputQueue : DispatchQueue = .init(label: "camera.output.queue", 
                                                    qos: .userInteractive)
    
    private var session : AVCaptureSession?
    private var cameraLayer : AVCaptureVideoPreviewLayer?
    
    private var isDetecting : Bool = false
    
    private weak var delegate : HandDetectionViewDelegate?
    
    private func setupSession() -> () {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, 
                                                   for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device)
        else { return }
        
        let session = AVCaptureSession()
        
        session.beginConfiguration()
        session.sessionPreset = .photo
        
        guard session.canAddInput(input) else { return }
        session.addInput(input)
        
        let output = AVCaptureVideoDataOutput()
        
        guard session.canAddOutput(output) else { return }
        session.addOutput(output)
        
        output.alwaysDiscardsLateVideoFrames = true
        output.setSampleBufferDelegate(self, queue: self.outputQueue)
        
        session.commitConfiguration()
        
        self.cameraLayer = .init(session: session)
        self.cameraLayer?.videoGravity = .resizeAspectFill
        self.cameraLayer?.connection?.videoOrientation = .landscapeRight
        self.cameraLayer?.frame = self.frame
        
        self.session = session
    }
    
    @objc private func handleOrientationChange(notification : NSNotification) -> () {
        let currentOrientation = UIDevice.current.orientation
        print(currentOrientation.rawValue)
        
        switch currentOrientation {
        case .landscapeLeft: self.cameraLayer?.connection?.videoOrientation = .landscapeLeft
        case .landscapeRight: self.cameraLayer?.connection?.videoOrientation = .landscapeRight
        case .portrait: self.cameraLayer?.connection?.videoOrientation = .portrait
        case .portraitUpsideDown: self.cameraLayer?.connection?.videoOrientation = .portraitUpsideDown
        default: break
        }
    }
    
    private func convertedPoint(for joint : VNHumanHandPoseObservation.JointName, at points : [VNHumanHandPoseObservation.JointName : CGPoint]) -> CGPoint? {
        guard let point = points[joint] else { return nil }
        return self.cameraLayer?.layerPointConverted(fromCaptureDevicePoint: point)
    }
    
    private func fingerPoints(from observation : VNHumanHandPoseObservation) -> [VNHumanHandPoseObservation.JointName : CGPoint] {
        var points : [VNHumanHandPoseObservation.JointName : VNRecognizedPoint] = .init()
        
        let hand = try! observation.recognizedPoints(.all)
        
        if let thumbTip = hand[.thumbTip],
           let thumbIP = hand[.thumbIP], 
           let thumbMP = hand[.thumbMP],
           let thumbCMC = hand[.thumbCMC] {
            points[.thumbTip] = thumbTip
            points[.thumbIP] = thumbIP
            points[.thumbMP] = thumbMP
            points[.thumbCMC] = thumbCMC
        }
        
        if let indexTip = hand[.indexTip],
           let indexDIP = hand[.indexDIP],
           let indexPIP = hand[.indexPIP],
           let indexMCP = hand[.indexMCP] {
            points[.indexTip] = indexTip
            points[.indexDIP] = indexDIP
            points[.indexPIP] = indexPIP
            points[.indexMCP] = indexMCP
        }
        
        if let middleTip = hand[.middleTip],
           let middleDIP = hand[.middleDIP],
           let middlePIP = hand[.middlePIP],
           let middleMCP = hand[.middleMCP] {
            points[.middleTip] = middleTip
            points[.middleDIP] = middleDIP
            points[.middlePIP] = middlePIP
            points[.middleMCP] = middleMCP
        }
        
        if let ringTip = hand[.ringTip],
           let ringDIP = hand[.ringDIP],
           let ringPIP = hand[.ringPIP],
           let ringMCP = hand[.ringMCP] {
            points[.ringTip] = ringTip
            points[.ringDIP] = ringDIP
            points[.ringPIP] = ringPIP
            points[.ringMCP] = ringMCP
        }
        
        if let littleTip = hand[.littleTip],
           let littleDIP = hand[.littleDIP],
           let littlePIP = hand[.littlePIP],
           let littleMCP = hand[.littleMCP] {
            points[.littleTip] = littleTip
            points[.littleDIP] = littleDIP
            points[.littlePIP] = littlePIP
            points[.littleMCP] = littleMCP
        }
        
        if let wrist = hand[.wrist] {
            points[.wrist] = wrist
        }
        
        var filteredPoints = points.filter { $0.value.confidence > 0.3 }.mapValues { value in
            return CGPoint(x: value.location.x, y: 1 - value.location.y)
        }
        
        for (key, value) in filteredPoints {
            filteredPoints[key] = self.convertedPoint(for: key, at: filteredPoints)
        }
        
        return filteredPoints
    }
    
    private func process(result : VNHumanHandPoseObservation) -> () {
        let fingerPoints = self.fingerPoints(from: result)
        
        guard let thumb = Thumb(from: fingerPoints),
              let index = Finger(type: .indexFinger, from: fingerPoints),
              let middle = Finger(type: .middleFinger, from: fingerPoints),
              let ring = Finger(type: .ringFinger, from: fingerPoints),
              let little = Finger(type: .littleFinger, from: fingerPoints),
              let wrist = fingerPoints[.wrist]
        else { return }
        
        let hand = Hand(thumbFinger: thumb, indexFinger: index, 
                        middleFinger: middle, ringFinger: ring, 
                        littleFinger: little, wrist: wrist)
        self.delegate?.detected(hand: hand)
    }
    
    public func startDetecting() -> () {
        self.isDetecting = true
    }
    
    public func stopDetecting() -> () {
        self.isDetecting = false
    }
    
    public func startSession() -> () { 
        self.session?.startRunning() 
    }
    
    public func stopSession() -> () { 
        self.session?.stopRunning() 
    }
    
    override public func layoutSubviews() -> () {
        super.layoutSubviews()
        self.cameraLayer?.frame = self.frame
    }
    
    public convenience init(delegate : HandDetectionViewDelegate?) {
        self.init()
        self.delegate = delegate
    }
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupSession()
        self.translatesAutoresizingMaskIntoConstraints = false
        
        guard let cameraLayer = self.cameraLayer else { return }
        self.layer.addSublayer(cameraLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HandDetectionView : AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput, 
                              didOutput sampleBuffer: CMSampleBuffer, 
                              from connection: AVCaptureConnection) -> () {
        
        guard self.isDetecting else { return }
        
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: .init())
        
        do {
            try handler.perform([self.handRequest])
            
            guard let result = self.handRequest.results?.first as? VNHumanHandPoseObservation,
                  self.isDetecting
            else { return }
            
            self.process(result: result)
        } catch {
            print(error)
        }
    }
    
}

