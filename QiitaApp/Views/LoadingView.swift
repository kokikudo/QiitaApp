import UIKit

class LoadingView: UIView {
        
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private lazy var spinner: UIView = {
       let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.1)
        view.frame.size = CGSize(width: 200, height: 200)
        view.layer.cornerRadius = 20
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        return view
    }()
    
    override var isHidden: Bool {
        didSet {
            isHidden ? stopAnimating() : startAnimating()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .clear
        
        let center = center
        let yOffset: CGFloat = -100
        spinner.center = CGPoint(x: center.x, y: center.y + yOffset)
        addSubview(spinner)
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}
