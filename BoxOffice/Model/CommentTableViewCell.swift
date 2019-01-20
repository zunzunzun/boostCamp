//
//  CommentTableViewCell.swift
//  BoxOffice
//
//  Created by LEE JUNSANG on 2018. 12. 17..
//  Copyright © 2018년 zunzun. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func settingUserRating(rating: Double) {
        var index: Int = 0
        var value: Double = 2
        while(true) {
            if rating >= value {
                if let imageView = self.ratingStackView.arrangedSubviews[index] as? UIImageView {
                    imageView.image = UIImage(named: "icStar")
                }
                value = value + 2
                index = index + 1
            } else {
                value = value - 1
                if rating >= value {
                    if let imageView = self.ratingStackView.arrangedSubviews[index] as? UIImageView {
                        imageView.image = UIImage(named: "icHalfStar")
                    }
                    return
                } else {
                    return
                }
            }
        }
        
    }
    
}
