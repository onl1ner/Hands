import UIKit

final public class HomeHintView : UIView {
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20.0, weight: .medium)
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var textLabel : UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18.0)
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var infoSymbolImageView : UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "info.circle")
        imageView.preferredSymbolConfiguration = .init(pointSize: 24.0, weight: .bold)
        imageView.tintColor = .secondaryLabel
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private func applyConstraints() -> () {
        NSLayoutConstraint.activate([
            self.infoSymbolImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            self.infoSymbolImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0)
        ])
        
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.infoSymbolImageView.leadingAnchor, constant: -16.0),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0)
        ])
        
        NSLayoutConstraint.activate([
            self.textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            self.textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            self.textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16.0)
        ])
    }
    
    public convenience init(title : String, text : String) {
        self.init()
        
        self.titleLabel.text = title
        self.textLabel.text = text
    }
    
    override internal init(frame : CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.infoSymbolImageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.textLabel)
        
        self.layer.cornerRadius = 16.0
        self.backgroundColor = .secondarySystemBackground
        
        self.applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

