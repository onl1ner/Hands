
import UIKit

final public class HomeButton : UIButton {
    
    private lazy var textLabel : UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var symbolImageView : UIImageView = {
        let imageView = UIImageView()
        
        imageView.preferredSymbolConfiguration = .init(pointSize: 24.0, weight: .bold)
        imageView.tintColor = .systemBlue
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    @objc private func focus() {
        UIView.animate(withDuration: 0.2) {
            self.transform = .init(scaleX: 0.98, y: 0.98)
        }
    }
    
    @objc private func unfocus() {
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
        }
    }
    
    private func applyConstraints() -> () {
        NSLayoutConstraint.activate([
            self.textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            self.textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            self.textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            self.symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            self.symbolImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0)
        ])
    }
    
    public convenience init(text : String, symbolName : String) {
        self.init()
        
        self.textLabel.text = text
        self.symbolImageView.image = UIImage(systemName: symbolName)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.textLabel)
        self.addSubview(self.symbolImageView)
        
        self.layer.cornerRadius = 16.0
        self.backgroundColor = .secondarySystemBackground
        
        self.applyConstraints()
        
        self.addTarget(self, action: #selector(self.focus), for: .touchDown)
        self.addTarget(self, action: #selector(self.focus), for: .touchDragEnter)
        
        self.addTarget(self, action: #selector(self.unfocus), for: .touchUpInside)
        self.addTarget(self, action: #selector(self.unfocus), for: .touchDragExit)
        self.addTarget(self, action: #selector(self.unfocus), for: .touchCancel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

