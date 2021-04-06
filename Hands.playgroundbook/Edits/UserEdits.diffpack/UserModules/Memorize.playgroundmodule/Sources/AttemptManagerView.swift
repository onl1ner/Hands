
import UIKit

protocol AttemptManagerViewDelegate : class {
    func noAttemptsLeft() -> ()
}

final class AttemptManagerView : UIView {
    
    private lazy var currentAttemptLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24.0, weight: .bold)
        return label
    }()
    
    private lazy var attemptLabel : UILabel = {
        let label = UILabel()
        
        label.text = "Attempts"
        
        label.font = .systemFont(ofSize: 18.0)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private lazy var stackView : UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8.0
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private weak var delegate : AttemptManagerViewDelegate?
    
    private var maxAttempts : Int = 0
    
    private var currentAttempt : Int = 0 {
        didSet {
            self.currentAttemptLabel.text = "\(self.currentAttempt) / \(self.maxAttempts)"
        }
    }
    
    private func applyConstraints() -> () {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: self.stackView.topAnchor, constant: -16.0),
            self.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor, constant: -16.0),
            self.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor, constant: 16.0),
            self.bottomAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 16.0)
        ])
    }
    
    public func incrementAttempt() -> () {
        guard self.currentAttempt < self.maxAttempts else { return }
        self.currentAttempt += 1
    }
    
    public func decrementAttempt() -> () {
        guard self.currentAttempt - 1 > 0 else {
            self.delegate?.noAttemptsLeft()
            return
        }
        
        self.currentAttempt -= 1
    }
    
    public convenience init(maxAttempts : Int, delegate : AttemptManagerViewDelegate) {
        self.init()
        
        self.delegate = delegate
        
        self.maxAttempts = maxAttempts
        self.currentAttempt = maxAttempts
        
        self.currentAttemptLabel.text = "\(self.currentAttempt) / \(self.maxAttempts)"
    }
    
    override internal init(frame : CGRect) {
        super.init(frame: frame)
        
        self.stackView.addArrangedSubview(self.currentAttemptLabel)
        self.stackView.addArrangedSubview(self.attemptLabel)
        
        self.addSubview(self.stackView)
        
        self.layer.cornerRadius = 16.0
        self.backgroundColor = .secondarySystemBackground
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
