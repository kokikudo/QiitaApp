//
//  ArticleTableViewCell.swift
//  QiitaApp
//
//  Created by kudo koki on 2023/08/12.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likesCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(_ data: ArticleData) {
        createDateLabel.text = data.createdAt
        titleLabel.text = data.title
        likesCount.text = data.likeCount?.description
    }
    
}
