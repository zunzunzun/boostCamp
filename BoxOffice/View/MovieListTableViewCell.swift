//
//  MovieListTableViewCell.swift
//  BoxOffice
//
//  Created by LEE JUNSANG on 2018. 12. 16..
//  Copyright © 2018년 zunzun. All rights reserved.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var ageImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailInfoLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setup(_ movie: Movie) {
        titleLabel.text = movie.title
        ageImageView.image = UIImage(named: movie.imageString)
        detailInfoLabel.text = "평점 : \(movie.userRating)  예매순위 : \(movie.reservationGrade)  예매율 : \(movie.reservationRate)"
        releaseDateLabel.text = "개봉일 : \(movie.date)"
        if let url = URL(string: movie.thumb) {
            Network.fetchImage(url) { [weak self] data, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let data = data else { return }
                let image = UIImage(data: data)
                self?.posterImageView.image = image
            }
        }
    }
}
