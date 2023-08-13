import UIKit

class ErrorPopupViewController: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var errorTextLabel: UILabel!
    
    private var dismissCompletion: (() -> Void)?
    private var errorText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorTextLabel.text = errorText
    }

    func setData(errorText: String, dismissCompletion: (() -> Void)? = nil) {
        self.errorText = errorText
        self.dismissCompletion = dismissCompletion
    }
    
    @IBAction func actionDismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: dismissCompletion)
    }
    
}
