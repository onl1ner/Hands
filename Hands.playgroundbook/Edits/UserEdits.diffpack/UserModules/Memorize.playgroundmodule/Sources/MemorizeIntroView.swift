import UIKit

protocol MemorizeIntroViewDelegate : class {
    func shouldStartGame() -> ()
    func shouldCloseGame() -> ()
}

final class MemorizeIntroView : UIView {
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        
        label.text = "About game"
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var textLabel : UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18.0)
        label.text = "Memorize the sequence that will be shown in the beginning and repeat it."
        
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var playButton : UIButton = {
        let button = UIButton()
        
        button.setTitle(" Play", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 18.0), forImageIn: .normal)
        
        button.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .bold)
        
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        
        button.layer.cornerRadius = 16.0
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(self.playButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var backButton : UIButton = {
        let button = UIButton() 
        
        button.setImage(UIImage(systemName: "arrow.left.circle.fill"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 18.0), forImageIn: .normal)
        
        button.tintColor = .systemBlue
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        
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
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private weak var delegate : MemorizeIntroViewDelegate?
    
    @objc private func playButtonPressed() -> () {
        self.hide {
            self.delegate?.shouldStartGame()
        }
    }
    
    @objc private func backButtonPressed() -> () {
        self.hide {
            self.delegate?.shouldCloseGame()
        }
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
            self.playButton.heightAnchor.constraint(equalToConstant: 40),
            self.playButton.widthAnchor.constraint(equalToConstant: 256)
        ])
        
        NSLayoutConstraint.activate([
            self.backButton.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 16.0),
            self.backButton.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 16.0)
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
    
    public convenience init(delegate : MemorizeIntroViewDelegate?) {
        self.init()
        self.delegate = delegate
    }
    
    override public init(frame : CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.textLabel)
        self.stackView.addArrangedSubview(self.playButton)
        
        self.containerView.addSubview(self.stackView)
        self.containerView.addSubview(self.backButton)
        
        self.addSubview(self.containerView)
        
        self.applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
