//
//  RatingEnabled.swift
//  BoxOffice
//
//  Created by Presto on 20/01/2019.
//  Copyright © 2019 zunzun. All rights reserved.
//

import UIKit

protocol RatingEnabled {
    func setUserRating(_ rating: Double, to stackView: UIStackView)
}

extension RatingEnabled {
    func setUserRating(_ rating: Double, to stackView: UIStackView) {
        var index: Int = 0
        var value: Double = 2
        while true {
            if rating >= value {
                if let imageView = stackView.arrangedSubviews[index] as? UIImageView {
                    imageView.image = UIImage(named: "icStar")
                }
                value = value + 2
                index = index + 1
            } else {
                value = value - 1
                if rating >= value {
                    if let imageView = stackView.arrangedSubviews[index] as? UIImageView {
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
