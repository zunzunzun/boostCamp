//
//  MovieDetailInfoViewController.swift
//  BoxOffice
//
//  Created by LEE JUNSANG on 2018. 12. 17..
//  Copyright © 2018년 zunzun. All rights reserved.
//

import UIKit

class MovieDetailInfoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movieDetailInfo: MovieDetailInfo?
    var commentList: CommentsList?
    var id: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestData()
    }
}

extension MovieDetailInfoViewController {
    func setup() {
        tableView.register(UINib(nibName: DetailInfoTableViewCell.description, bundle: nil), forCellReuseIdentifier: Constant.movieDetailInfoCellIdentifier)
        tableView.register(UINib(nibName: SynopsisTableViewCell.description, bundle: nil), forCellReuseIdentifier: Constant.movieDetailSynopsisCellIdentifier)
        tableView.register(UINib(nibName: ActorTableViewCell.description, bundle: nil), forCellReuseIdentifier: Constant.movieDetailActorCellIdentifier)
        tableView.register(UINib(nibName: CommentTableViewCell.description, bundle: nil), forCellReuseIdentifier: Constant.movieDetailCommentCellIdentifier)
    }
    
    func requestData() {
        API.shared.requestDetailInfo(movieID: id) { movieDetailInfo, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.movieDetailInfo = movieDetailInfo
            API.shared.requestComment(movieID: self.id) { commentList, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self.commentList = commentList
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

extension MovieDetailInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        } else if section == 3 {
            return commentList?.comments.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        } else if indexPath.section == 1 {
            return 500
        } else if indexPath.section == 2 {
            return 100
        }
        return 100
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.movieDetailInfoCellIdentifier, for: indexPath) as? DetailInfoTableViewCell else {
                return UITableViewCell()
            }
            if let detailInfo = self.movieDetailInfo {
                cell.titleLabel.text = detailInfo.title
                cell.releaseDateLabel.text = detailInfo.date + " 개봉"
                cell.genreLabel.text = detailInfo.genre + "/\(detailInfo.duration)분"
                cell.reservationLabel.text = "\(detailInfo.reservationGrade)위 \(detailInfo.reservationRate)%"
                cell.ratingLabel.text = "\(detailInfo.userRating)"
                cell.audienceLabel.text = detailInfo.audienceString
                cell.setUserRating(to: detailInfo.userRating)
                switch movieDetailInfo?.grade {
                case 0:
                    cell.ageImageView.image = UIImage(named: "icAllAges")
                case 12:
                    cell.ageImageView.image = UIImage(named: "ic12")
                case 15:
                    cell.ageImageView.image = UIImage(named: "ic15")
                case 19:
                    cell.ageImageView.image = UIImage(named: "ic19")
                default:
                    cell.ageImageView.image = nil
                }
                OperationQueue().addOperation {
                    if let imageURL = URL(string: detailInfo.image) {
                        do {
                            let imageData = try Data.init(contentsOf: imageURL)
                            let image = UIImage(data: imageData)
                            DispatchQueue.main.async {
                                cell.posterImageView.image = image
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.movieDetailSynopsisCellIdentifier, for: indexPath) as? SynopsisTableViewCell else {
                return UITableViewCell()
            }
            cell.textView.text = movieDetailInfo?.synopsis
            return cell
        } else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.movieDetailActorCellIdentifier, for: indexPath) as? ActorTableViewCell else {
                return UITableViewCell()
            }
            cell.directorLabel.text = movieDetailInfo?.director
            cell.actorLabel.text = movieDetailInfo?.actor
            cell.actorLabel.adjustsFontSizeToFitWidth = true
            return cell
        } else if indexPath.section == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.movieDetailCommentCellIdentifier, for: indexPath) as? CommentTableViewCell else {
                return UITableViewCell()
            }
            let comment = commentList?.comments[indexPath.row]
            cell.idLabel.text = comment?.writer
            let date = Date(timeIntervalSince1970: comment?.timestamp ?? 0)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            cell.dataLabel.text = dateFormatter.string(from: date)
            cell.textView.text = comment?.contents
            cell.setUserRating(to: comment?.rating ?? 0)
            return cell
        }
        return UITableViewCell()
    }
}
