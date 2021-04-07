import UIKit

protocol GameOverViewDelegate : class {
    func shouldProceedToMainMenu() -> ()
}

final class GameOverView : UIView {
    
    private lazy var levelLabel : UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 256.0, weight: .bold)
        label.textColor = .secondaryLabel
        label.alpha = 0.2
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        
        label.text = "Game over"
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var textLabel : UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18.0)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var mainMenuButton : UIButton = {
        let button = UIButton()
        
        button.setTitle(" Main menu", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.setImage(UIImage(systemName: "house.fill"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 18.0), forImageIn: .normal)
        
        button.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .bold)
        
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        
        button.layer.cornerRadius = 16.0
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(self.mainMenuButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var stackView : UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 16.0
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var containerView : UIView = {
        let view = UIView()
        
        view.backgroundColor = .tertiarySystemBackground
        view.layer.cornerRadius = 16.0
        
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private weak var delegate : GameOverViewDelegate?
    
    private var lowLevelText : String = "You lost"
    private var highLevelText : String = "You lost"
    
    @objc private func mainMenuButtonPressed() -> () {
        self.hide { self.delegate?.shouldProceedToMainMenu() }
    }
    
    private func hide(completion: @escaping () -> ()) -> () {
        UIView.animate(withDuration: 0.2, animations: { 
            self.containerView.alpha = 0.0
            self.containerView.transform = .init(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 0.0
            }, completion: { _ in
                completion()
            })
        })
    }
    
    private func applyConstraints() -> () {
        NSLayoutConstraint.activate([
            self.mainMenuButton.heightAnchor.constraint(equalToConstant: 40),
            self.mainMenuButton.widthAnchor.constraint(equalToConstant: 256)
        ])
        
        NSLayoutConstraint.activate([
            self.levelLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: -80.0),
            self.levelLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 8.0)
        ])
        
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.stackView.topAnchor, constant: -16.0),
            self.containerView.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor, constant: -16.0),
            self.containerView.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor, constant: 16.0),
            self.containerView.bottomAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 16.0),
            self.containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    public func show(with level : Int) -> () {
        self.levelLabel.text = String(level)
        self.textLabel.text = level > 4 ? self.lowLevelText : self.highLevelText
        
        UIView.animate(withDuration: 0.2, animations: { 
            self.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.containerView.alpha = 1.0
                self.containerView.transform = .identity
            }
        }
    }
    
    public convenience init(lowLevelText : String, highLevelText : String, delegate : GameOverViewDelegate?) {
        self.init()
        
        self.lowLevelText = lowLevelText
        self.highLevelText = highLevelText
        
        self.delegate = delegate
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.alpha = 0.0
        
        self.containerView.alpha = 0.0
        self.containerView.transform = .init(scaleX: 0.8, y: 0.8)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.textLabel)
        self.stackView.addArrangedSubview(self.mainMenuButton)
        
        self.containerView.addSubview(self.levelLabel)
        self.containerView.addSubview(self.stackView)
        
        self.addSubview(self.containerView)
        
        self.applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
