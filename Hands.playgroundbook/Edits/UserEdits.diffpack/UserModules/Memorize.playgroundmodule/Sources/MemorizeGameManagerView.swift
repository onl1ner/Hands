import UIKit
import Shared
import HandDetection

protocol MemorizeGameManagerViewDelegate : class {
    func shouldStartHandDetection() -> ()
    func shouldStopHandDetection() -> ()
    func gameOver(level : Int) -> ()
}

final class MemorizeGameManagerView : UIView {
    
    private lazy var levelManagerView = LevelManagerView()
    private lazy var attemptManagerView = AttemptManagerView(maxAttempts: 3)
    
    private lazy var statusLabel : UILabel = {
        let label = UILabel() 
        
        label.font = .systemFont(ofSize: 24.0, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var managerStackView : UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 16.0
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var sequenceView : UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.8)
        view.layer.cornerRadius = 16.0
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var sequenceStackView : UIStackView = { 
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let possibleHandGestures : [HandGesture] = [
        .init(requiredFinger: [.thumb, .indexFinger, .middleFinger, .ringFinger, .littleFinger], image: #imageLiteral(resourceName: "palm.png")),
        .init(requiredFinger: [.thumb], image: #imageLiteral(resourceName: "like.png")),
        .init(requiredFinger: [.thumb, .indexFinger, .middleFinger], image: #imageLiteral(resourceName: "pistol.png")),
        .init(requiredFinger: [.thumb, .indexFinger], image: #imageLiteral(resourceName: "point.png")),
        .init(requiredFinger: [.indexFinger], image: #imageLiteral(resourceName: "pointup.png")),
        .init(requiredFinger: [.thumb, .indexFinger, .littleFinger], image: #imageLiteral(resourceName: "horns.png")),
        .init(requiredFinger: [.thumb, .littleFinger], image: #imageLiteral(resourceName: "shaka.png"))
    ]
    
    /// Maximum sequence length that can be reached by user.
    private let maxSequenceLength : Int = 8
    
    /// Views of generated sequence of hand gestures.
    private var gestureViews : [MemorizeHandGestureView] = .init()
    
    /// Picking gestures for a sequence from this hand gesture pool.
    private var handGestureSequenceBuffer : [HandGesture] = .init()
    
    /// Hand gesture sequence, which contains the indexes of 
    /// picked gestures in the respective order.
    private var handGestureSequence : [Int] = .init()
    
    /// Current sequence length, which increases with the game level.
    private var currentSequenceLength : Int = 4
    
    /// Current gesture index that should be shown by user.
    private var currentSequenceIteration : Int = 0
    
    private weak var delegate : MemorizeGameManagerViewDelegate?
    
    private func applyConstraints() -> () {
        NSLayoutConstraint.activate([
            self.statusLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.statusLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.sequenceView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.sequenceView.heightAnchor.constraint(equalToConstant: 128.0),
            self.sequenceView.widthAnchor.constraint(equalToConstant: 512.0),
            self.sequenceView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            self.sequenceStackView.centerYAnchor.constraint(equalTo: self.sequenceView.centerYAnchor),
            self.sequenceStackView.leadingAnchor.constraint(equalTo: self.sequenceView.leadingAnchor, constant: 24.0),
            self.sequenceStackView.trailingAnchor.constraint(equalTo: self.sequenceView.trailingAnchor, constant: -24.0)
        ])
        
        NSLayoutConstraint.activate([
            self.managerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            self.managerStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16.0)
        ])
    }
    
    private func listenToUser() -> () {
        /// Give user some time to think.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { 
            self.delegate?.shouldStartHandDetection()
            
            UIView.animate(withDuration: 0.2) { 
                self.sequenceView.alpha = 0.4
            }
        }
    }
    
    private func focusGesture(at index : Int) -> () {
        let gestureIndex = self.handGestureSequence[index]
        let gestureView = self.gestureViews[gestureIndex]
        
        gestureView.focus()
    }
    
    private func showSequence() -> () {
        self.sequenceStackView.alpha = 0.0
        
        for gesture in self.handGestureSequenceBuffer {
            let view = MemorizeHandGestureView(image: gesture.image)
            
            self.gestureViews.append(view)
            self.sequenceStackView.addArrangedSubview(view)
        }
        
        UIView.animate(withDuration: 0.2, animations: { 
            self.layoutIfNeeded()
            self.sequenceStackView.alpha = 1.0
        }) { _ in
            var index = 0
            
            Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { timer in
                guard index < self.currentSequenceLength else { 
                    timer.invalidate()
                    self.listenToUser()
                    
                    return
                }
                
                self.focusGesture(at: index)
                index += 1
            }
        }
    }
    
    private func hideSequence(completion: (() -> ())? = nil) -> () {
        self.sequenceStackView.alpha = 1.0
        
        UIView.animate(withDuration: 0.2, animations: {
            self.sequenceStackView.alpha = 0.0
        }) { _ in
            self.sequenceStackView.subviews.forEach { $0.removeFromSuperview() }
            self.gestureViews = .init()
            
            completion?()
        }
    }
    
    private func success() -> () {
        self.levelManagerView.incrementLevel()
        self.delegate?.shouldStopHandDetection()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.sequenceView.alpha = 1.0
        }) { _ in 
            self.start()
        }
    }
    
    private func gameOver() -> () {
        self.delegate?.shouldStopHandDetection()
        
        self.hide()
        self.delegate?.gameOver(level: self.levelManagerView.currentLevel)
    }
    
    private func status(isRightGesture : Bool, completion: (() -> ())? = nil) -> () {
        self.delegate?.shouldStopHandDetection()
        
        self.statusLabel.transform = .init(scaleX: 0.8, y: 0.8)
        self.statusLabel.alpha = 0.0
        
        self.statusLabel.text = isRightGesture ? "Great 🥳" : "Try again 😕"
        
        UIView.animate(withDuration: 0.2, animations: {
            let color : UIColor = isRightGesture ? .systemGreen : .systemPink
            self.backgroundColor = color.withAlphaComponent(0.2)
            self.statusLabel.alpha = 1.0
            self.statusLabel.transform = .identity
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0.4, options: []) {
                self.backgroundColor = .clear
                self.statusLabel.alpha = 0.0
                self.statusLabel.transform = .init(scaleX: 0.8, y: 0.8)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { 
            self.delegate?.shouldStartHandDetection()
            completion?()
        }
    }
    
    private func start() -> () {
        self.hideSequence {
            self.handGestureSequenceBuffer = Array(self.possibleHandGestures.shuffled().prefix(4))
            
            self.currentSequenceLength += self.currentSequenceLength < self.maxSequenceLength ? Int(Double(self.levelManagerView.currentLevel) * 0.25) : 0
            
            self.currentSequenceIteration = 0
            self.handGestureSequence = .init()
            
            for i in 0 ..< self.currentSequenceLength {
                self.handGestureSequence.append(Int.random(in: 0 ..< 4))
            }
            
            self.showSequence()
        }
    }
    
    public func process(hand : Hand) -> () {
        let gestureIndex = self.handGestureSequence[self.currentSequenceIteration]
        let gesture = self.handGestureSequenceBuffer[gestureIndex]
        
        if hand.shows(gesture: gesture) {
            self.status(isRightGesture: true) {
                guard self.currentSequenceIteration + 1 < self.currentSequenceLength else {
                    self.success()
                    return
                } 
                
                self.currentSequenceIteration += 1
            }
        } else {
            self.status(isRightGesture: false) {
                guard self.attemptManagerView.hasAttempts else {
                    self.gameOver()
                    return
                }
                
                self.attemptManagerView.decrementAttempt()
            }
        }
    }
    
    public func show() -> () {
        UIView.animate(withDuration: 0.2, animations: { 
            self.alpha = 1.0
        }) { _ in
            self.start()
        }
    }
    
    public func hide() -> () {
        self.hideSequence()
        
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0.0
        }
    }
    
    public convenience init(delegate : MemorizeGameManagerViewDelegate?) {
        self.init()
        self.delegate = delegate
    }
    
    override public init(frame : CGRect) {
        super.init(frame: frame)
        
        self.managerStackView.addArrangedSubview(self.levelManagerView)
        self.managerStackView.addArrangedSubview(self.attemptManagerView)
        
        self.sequenceView.addSubview(self.sequenceStackView)
        
        self.addSubview(self.statusLabel)
        self.addSubview(self.managerStackView)
        self.addSubview(self.sequenceView)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
