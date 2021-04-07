import Foundation
import Vision

struct Thumb {
    public var tipPoint : CGPoint
    public var ipPoint : CGPoint
    public var mpPoint : CGPoint
    public var cmcPoint : CGPoint
    
    public func isExtended(wristPoint : CGPoint) -> Bool {
        return abs(CGPoint.angleBetween(first: self.tipPoint, second: self.ipPoint, third: self.mpPoint)) > 170.0 && 
            self.tipPoint.distance(from: wristPoint) > self.ipPoint.distance(from: wristPoint) &&
            self.ipPoint.distance(from: wristPoint) > self.mpPoint.distance(from: wristPoint) &&
            self.mpPoint.distance(from: wristPoint) > self.cmcPoint.distance(from: wristPoint)
    }
    
    public init?(from points : [VNHumanHandPoseObservation.JointName : CGPoint]) {
        guard let tipPoint = points[.thumbTip],
              let ipPoint = points[.thumbIP],
              let mpPoint = points[.thumbMP],
              let cmcPoint = points[.thumbCMC]
        else { return nil }
        
        self.tipPoint = tipPoint
        self.ipPoint = ipPoint
        self.mpPoint = mpPoint
        self.cmcPoint = cmcPoint
    }
}

struct Finger {
    public var tipPoint : CGPoint
    public var dipPoint : CGPoint
    public var pipPoint : CGPoint
    public var mcpPoint : CGPoint
    
    public func isExtended(wristPoint : CGPoint) -> Bool {
        return self.tipPoint.distance(from: wristPoint) > self.dipPoint.distance(from: wristPoint) &&
            self.dipPoint.distance(from: wristPoint) > self.pipPoint.distance(from: wristPoint) &&
            self.pipPoint.distance(from: wristPoint) > self.mcpPoint.distance(from: wristPoint)
    }
    
    public init?(type : VNHumanHandPoseObservation.JointsGroupName, from points : [VNHumanHandPoseObservation.JointName : CGPoint]) {
        var tip : VNHumanHandPoseObservation.JointName!
        var dip : VNHumanHandPoseObservation.JointName!
        var pip : VNHumanHandPoseObservation.JointName!
        var mcp : VNHumanHandPoseObservation.JointName!
        
        switch type {
        case .indexFinger:
            tip = .indexTip
            dip = .indexDIP
            pip = .indexPIP
            mcp = .indexMCP
        case .middleFinger:
            tip = .middleTip
            dip = .middleDIP
            pip = .middlePIP
            mcp = .middleMCP
        case .ringFinger:
            tip = .ringTip
            dip = .ringDIP
            pip = .ringPIP
            mcp = .ringMCP
        case .littleFinger:
            tip = .littleTip
            dip = .littleDIP
            pip = .littlePIP
            mcp = .littleMCP
        default: return nil
        }
        
        guard let tipPoint = points[tip],
              let dipPoint = points[dip],
              let pipPoint = points[pip],
              let mcpPoint = points[mcp]
        else { return nil }
        
        self.tipPoint = tipPoint
        self.dipPoint = dipPoint
        self.pipPoint = pipPoint
        self.mcpPoint = mcpPoint
    }
}

struct Hand {
    public var thumbFinger : Thumb
    public var indexFinger : Finger
    public var middleFinger : Finger
    public var ringFinger : Finger
    public var littleFinger : Finger
    
    public var wrist : CGPoint
    
    public func extendedFingers() -> [VNHumanHandPoseObservation.JointsGroupName] {
        var extendedFingers : [VNHumanHandPoseObservation.JointsGroupName] = .init()
        
        if thumbFinger.isExtended(wristPoint: self.wrist) { extendedFingers.append(.thumb) }
        if indexFinger.isExtended(wristPoint: self.wrist) { extendedFingers.append(.indexFinger) }
        if middleFinger.isExtended(wristPoint: self.wrist) { extendedFingers.append(.middleFinger) }
        if ringFinger.isExtended(wristPoint: self.wrist) { extendedFingers.append(.ringFinger) }
        if littleFinger.isExtended(wristPoint: self.wrist) { extendedFingers.append(.littleFinger) }
        
        return extendedFingers
    }
    
    public func shows(gesture : HandGesture) -> Bool {
        return gesture.requiredFingers == self.extendedFingers()
    }
    
}
