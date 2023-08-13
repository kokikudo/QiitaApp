//
//  UserSearchInputView.swift
//  QiitaApp
//
//  Created by kudo koki on 2023/08/12.
//

import UIKit

class UserSearchInputView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textField: UITextField!
    
    override init(frame: CGRect) {
            super.init(frame: frame)

            commitInit()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)

            commitInit()
        }
    
    private func commitInit() {
        let view = UINib(nibName: "UserSearchInputView", bundle: nil)
            .instantiate(withOwner: self)
            .first as! UIView
        view.frame = bounds
        addSubview(view)
        view.autoresizingMask =  [.flexibleWidth, .flexibleHeight]
    }

}
