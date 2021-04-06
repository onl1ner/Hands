import UIKit

final public class HomeViewController : UIViewController {
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 64.0, weight: .bold)
        label.text = "Hands –"
        
        return label
    }()
    
    private lazy var subtitleLabel : UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 32.0)
        label.text = "keep your brain in a good shape!"
        
        return label
    }()
    
    private lazy var titleStackView : UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 4.0
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var memorizeSequenceModeButton = HomeButton(text: "Memorize the sequence", symbolName: "memories")
    private lazy var repeatSequenceModeButton = HomeButton(text: "Repeat the sequence", symbolName: "repeat")
    
    private lazy var hintView = HomeHintView(title: "What is it?", 
                                             text: "Each of the game modes is a great opportunity to keep your brain in good shape. Such training will help to maintain brain activity and thus keep a clear mind and a strong memory until old age.")
    
    private lazy var mainStackView : UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 16.0
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var mainButtonStackView : UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 16.0
        stackView.distribution = .fill
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var buttonStackView : UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 16.0
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    @objc private func memorizeSequenceModeButtonPressed() -> () {
        let memorizeVC = MemorizeViewController()
        
        memorizeVC.modalTransitionStyle = .crossDissolve
        memorizeVC.modalPresentationStyle = .fullScreen
        
        self.present(memorizeVC, animated: true, completion: nil)
    }
    
    @objc private func repeatSequenceModeButtonPressed() -> () {
        
    }
    
    private func applyConstraints() -> () {
        NSLayoutConstraint.activate([
            self.mainStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.mainStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.memorizeSequenceModeButton.heightAnchor.constraint(equalToConstant: 128.0),
            self.repeatSequenceModeButton.heightAnchor.constraint(equalToConstant: 128.0),
            self.hintView.widthAnchor.constraint(equalToConstant: 256.0)
        ])
    }
    
    override public func viewDidLoad() -> () {
        super.viewDidLoad()
        
        self.memorizeSequenceModeButton.addTarget(self, action: #selector(self.memorizeSequenceModeButtonPressed), for: UIControl.Event.touchUpInside)
        self.repeatSequenceModeButton.addTarget(self, action: #selector(self.repeatSequenceModeButtonPressed), for: UIControl.Event.touchUpInside)
        
        self.titleStackView.addArrangedSubview(self.titleLabel)
        self.titleStackView.addArrangedSubview(self.subtitleLabel)
        
        self.buttonStackView.addArrangedSubview(self.memorizeSequenceModeButton)
        self.buttonStackView.addArrangedSubview(self.repeatSequenceModeButton)
        
        self.mainButtonStackView.addArrangedSubview(self.buttonStackView)
        self.mainButtonStackView.addArrangedSubview(self.hintView)
        
        self.mainStackView.addArrangedSubview(self.titleStackView)
        self.mainStackView.addArrangedSubview(self.mainButtonStackView)
        
        self.view.addSubview(self.mainStackView)
        
        self.view.backgroundColor = .systemBackground
        
        self.applyConstraints()
    }
    
}

