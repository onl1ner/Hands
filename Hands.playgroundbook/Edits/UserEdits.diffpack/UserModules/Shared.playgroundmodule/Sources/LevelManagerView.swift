import UIKit

final public class LevelManagerView : UIView {
    
    private lazy var currentLevelLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24.0, weight: .bold)
        return label
    }()
    
    private lazy var levelLabel : UILabel = {
        let label = UILabel()
        
        label.text = "Level"
        
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
    
    public private(set) var currentLevel : Int = 1 {
        didSet {
            self.currentLevelLabel.text = String(self.currentLevel)
        }
    }
    
    private func applyConstraints() -> () {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: self.stackView.topAnchor, constant: -16.0),
            self.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor, constant: -16.0),
            self.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor, constant: 16.0),
            self.bottomAnchor.constraint(lessThanOrEqualTo: self.stackView.bottomAnchor, constant: 16.0)
        ])
    }
    
    public func incrementLevel() -> () {
        self.currentLevel += 1
    }
    
    override public init(frame : CGRect) {
        super.init(frame: frame)
        
        self.stackView.addArrangedSubview(self.currentLevelLabel)
        self.stackView.addArrangedSubview(self.levelLabel)
        
        self.addSubview(self.stackView)
        
        self.layer.cornerRadius = 16.0
        self.backgroundColor = .secondarySystemBackground
        
        self.currentLevelLabel.text = String(self.currentLevel)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.applyConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
