import UIKit

final class RepeatGameManagerView : UIView {
    
    private lazy var levelManagerView = LevelManagerView()
    private lazy var attemptManagerView = AttemptManagerView(maxAttempts: 5, delegate : self)
    
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
    
    private lazy var focusRectView : UIView = {
        let view = UIView()
        
        view.backgroundColor = .clear
        
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.layer.borderWidth = 2
        
        view.layer.cornerRadius = 16.0
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private weak var delegate : GameManagerDelegate?
    
    private let possibleHandGestures : [HandGesture] = [
        .init(requiredFinger: [.thumb, .indexFinger, .middleFinger, .ringFinger, .littleFinger], image: #imageLiteral(resourceName: "palm.png")),
        .init(requiredFinger: [.thumb], image: #imageLiteral(resourceName: "like.png")),
        .init(requiredFinger: [.thumb, .indexFinger, .middleFinger], image: #imageLiteral(resourceName: "pistol.png")),
        .init(requiredFinger: [.thumb, .indexFinger], image: #imageLiteral(resourceName: "point.png")),
        .init(requiredFinger: [.indexFinger], image: #imageLiteral(resourceName: "pointup.png")),
        .init(requiredFinger: [.thumb, .indexFinger, .littleFinger], image: #imageLiteral(resourceName: "horns.png")),
        .init(requiredFinger: [.thumb, .littleFinger], image: #imageLiteral(resourceName: "shaka.png"))
    ]
    
    /// Time that gesture view takes to travel from one side to another.
    private let travelTime : Double = 10.0
    
    /// Ratio that indicates the frequency of sequence.
    private var stepRatio : Double = 4.0
    
    /// Gesture queue of presenting sequence. First element is the gesture that user have to show.
    private var gestureQueue : [HandGesture] = .init()
    
    private func instanceHand() -> () {
        let gesture = self.possibleHandGestures.randomElement()!
        let gestureView = HandGestureView(image: gesture.image)
        
        gestureView.alpha = 0.0
        
        // 64 – stands for the size of the image
        // 32 – is the padding of the imageView, 16 by each side.
        gestureView.frame = .init(x: self.sequenceView.bounds.maxX,
                              y: self.sequenceView.bounds.midY - (64 + 32) / 2, 
                              width: 64 + 32, height: 64 + 32)
        
        self.sequenceView.insertSubview(gestureView, belowSubview: self.focusRectView)
        self.gestureQueue.append(gesture)
        
        UIView.animateKeyframes(withDuration: self.travelTime, delay: 0.0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) { 
                gestureView.layer.position.x = 0.0
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.1) {
                gestureView.alpha = 1.0
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.1) { 
                gestureView.alpha = 0.0
                
            }
        }) { _ in 
            gestureView.removeFromSuperview()
        }
    }
    
    private func start() -> () {
        let timer = Timer.scheduledTimer(withTimeInterval: self.travelTime / self.stepRatio, 
                                         repeats: true) { _ in
            self.instanceHand()
            
            Timer.scheduledTimer(withTimeInterval: self.travelTime / 2 - 0.5, repeats: false) { _ in
                print(self.gestureQueue.first)
            }
            
            Timer.scheduledTimer(withTimeInterval: self.travelTime / 2 + 0.5, repeats: false) { _ in
                self.gestureQueue.removeFirst()
            }
        }
    }
    
    private func applyConstraints() -> () {
        NSLayoutConstraint.activate([
            self.sequenceView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.sequenceView.heightAnchor.constraint(equalToConstant: 128.0),
            self.sequenceView.widthAnchor.constraint(equalToConstant: 512.0),
            self.sequenceView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            self.focusRectView.heightAnchor.constraint(equalTo: self.sequenceView.heightAnchor, multiplier: 0.8),
            self.focusRectView.widthAnchor.constraint(equalTo: self.focusRectView.heightAnchor, multiplier: 1.0),
            self.focusRectView.centerXAnchor.constraint(equalTo: self.sequenceView.centerXAnchor),
            self.focusRectView.centerYAnchor.constraint(equalTo: self.sequenceView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.managerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            self.managerStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16.0)
        ])
    }
    
    public func process(hand : Hand) -> () {
        
    }
    
    public func show() -> () {
        UIView.animate(withDuration: 0.2, animations: { 
            self.alpha = 1.0
        }) { _ in
            self.start()
        }
    }
    
    public func hide() -> () {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0.0
        }
    }
    
    public convenience init(delegate : GameManagerDelegate?) {
        self.init()
        self.delegate = delegate
    }
    
    override public init(frame : CGRect) {
        super.init(frame: frame)
        
        self.managerStackView.addArrangedSubview(self.levelManagerView)
        self.managerStackView.addArrangedSubview(self.attemptManagerView)
        
        self.sequenceView.addSubview(self.focusRectView)
        
        self.addSubview(self.managerStackView)
        self.addSubview(self.sequenceView)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RepeatGameManagerView : AttemptManagerViewDelegate {
    
    public func noAttemptsLeft() -> () {
        
    }
    
}
