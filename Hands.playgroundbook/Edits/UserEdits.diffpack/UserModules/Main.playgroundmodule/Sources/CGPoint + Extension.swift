import CoreGraphics

extension CGPoint {
    
    public func distance(from point : CGPoint) -> CGFloat {
        return hypot(point.x - self.x, point.y - self.y)
    }
    
    public static func angleBetween(first: CGPoint, second: CGPoint, third: CGPoint) -> Double {
        let firstVector = CGVector(dx: first.x - second.x, dy: first.y - second.y)
        let secondVector = CGVector(dx: third.x - second.x, dy: third.y - second.y)
        
        let firstTheta = atan2(firstVector.dy, firstVector.dx)
        let secondTheta = atan2(secondVector.dy, secondVector.dx)
        
        let angle = firstTheta - secondTheta
        
        return (Double(angle) * 180.0) / Double.pi
    }
}
