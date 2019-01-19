//
//  DetailInfoTableViewCell.swift
//  BoxOffice
//
//  Created by LEE JUNSANG on 2018. 12. 17..
//  Copyright © 2018년 zunzun. All rights reserved.
//

import UIKit

class DetailInfoTableViewCell: UITableViewCell, RatingEnabled {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var ageImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var reservationLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var audienceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let imageView = ratingStackView.arrangedSubviews.first as? UIImageView {
            imageView.image = UIImage(named: "icHalfStar")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
