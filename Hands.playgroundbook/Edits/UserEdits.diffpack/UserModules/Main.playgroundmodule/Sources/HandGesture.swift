import UIKit
import Vision

struct HandGesture {
    
    public var requiredFingers : [VNHumanHandPoseObservation.JointsGroupName]
    public var image : UIImage?
    
    public init(requiredFinger : [VNHumanHandPoseObservation.JointsGroupName], 
                image : UIImage? = UIImage(systemName: "hand.raised.fill")) {
        self.requiredFingers = requiredFinger
        self.image = image
    }
    
}
