//
//  DetailInfoTableViewCell.swift
//  BoxOffice
//
//  Created by LEE JUNSANG on 2018. 12. 17..
//  Copyright © 2018년 zunzun. All rights reserved.
//

import UIKit

class DetailInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var ageImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var reservationLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: UIStackView!
    @IBOutlet weak var audienceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let view = self.ratingView.arrangedSubviews[0] as! UIImageView
        view.image = UIImage(named: "icHalfStar")
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
                if let imageView = self.ratingView.arrangedSubviews[index] as? UIImageView {
                    imageView.image = UIImage(named: "icStar")
                }
                value = value + 2
                index = index + 1
            } else {
                value = value - 1
                if rating >= value {
                    if let imageView = self.ratingView.arrangedSubviews[index] as? UIImageView {
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
