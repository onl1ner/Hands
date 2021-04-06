protocol GameManagerDelegate : class {
    func shouldStartHandDetection() -> ()
    func shouldStopHandDetection() -> ()
    func gameOver(level : Int) -> ()
}
