import UIKit

final class MemorizeHandGestureView : UIView {
    
    private lazy var handGestureImageView : UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private func applyConstraints() -> () {
        NSLayoutConstraint.activate([
            self.handGestureImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0),
            self.handGestureImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            self.handGestureImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            self.handGestureImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16.0),
            self.handGestureImageView.heightAnchor.constraint(equalToConstant: 64.0),
            self.handGestureImageView.widthAnchor.constraint(equalToConstant: 64.0)
        ])
    }
    
    public func focus() -> () {
        UIView.animate(withDuration: 0.2, animations: {
            self.handGestureImageView.transform = .init(scaleX: 1.5, y: 1.5)
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0.8, options: .init()) { 
                self.handGestureImageView.transform = .identity
            }
        }
    }
    
    public convenience init(image : UIImage?) {
        self.init()
        self.handGestureImageView.image = image
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.handGestureImageView)
        self.applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
