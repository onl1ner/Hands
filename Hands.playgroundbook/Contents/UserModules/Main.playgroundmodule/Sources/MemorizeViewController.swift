import UIKit

final class MemorizeViewController : UIViewController {
    
    private lazy var introView = IntroView(text: "Memorize the sequence that will be shown in the beginning and repeat it!", 
                                           delegate: self)
    private lazy var gameOverView = GameOverView(lowLevelText: "You have perfectly trained your memory, do such training regularly and you will immediately notice the result.",
                                                 highLevelText: "Conduct such training regularly and you will immediately notice the result.",
                                                 delegate: self)
    
    private lazy var managerView = MemorizeGameManagerView(delegate: self)
    private lazy var handDetectionView = HandDetectionView(delegate: self)
    
    private func toMainMenu() -> () {
        let homeVC = HomeViewController()
        
        homeVC.modalTransitionStyle = .crossDissolve
        homeVC.modalPresentationStyle = .fullScreen
        
        self.present(homeVC, animated: true, completion: nil)
    }
    
    private func applyConstraints() -> () {
        NSLayoutConstraint.activate([
            self.introView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.introView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.introView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.introView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.gameOverView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.gameOverView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.gameOverView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.gameOverView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.managerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.managerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.managerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.managerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.handDetectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.handDetectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.handDetectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.handDetectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    override internal func viewDidLoad() -> () {
        super.viewDidLoad()
        
        self.view.addSubview(self.handDetectionView)
        self.view.addSubview(self.managerView)
        self.view.addSubview(self.gameOverView)
        self.view.addSubview(self.introView)
        
        self.view.backgroundColor = .systemBackground
        self.managerView.hide()
        
        self.applyConstraints()
        
        self.handDetectionView.startSession()
    }
}

extension MemorizeViewController : IntroViewDelegate {
    public func shouldStartGame() -> () {
        self.managerView.show()
    }
    
    public func shouldCloseGame() -> () {
        self.toMainMenu()
    }
}

extension MemorizeViewController : GameManagerDelegate {
    public func shouldStartHandDetection() -> () {
        self.handDetectionView.startDetecting()
    }
    
    public func shouldStopHandDetection() -> () {
        self.handDetectionView.stopDetecting()
    }
    
    public func gameOver(level : Int) -> () {
        self.gameOverView.show(with: level)
    }
}

extension MemorizeViewController : GameOverViewDelegate {
    public func shouldProceedToMainMenu() -> () {
        self.toMainMenu()
    }
}

extension MemorizeViewController : HandDetectionViewDelegate {
    public func detected(hand : Hand) -> () {
        self.managerView.process(hand: hand)
    }
}
