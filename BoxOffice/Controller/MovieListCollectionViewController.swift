//
//  MovieListCollectionViewController.swift
//  BoxOffice
//
//  Created by LEE JUNSANG on 2018. 12. 17..
//  Copyright © 2018년 zunzun. All rights reserved.
//

import UIKit

class MovieListCollectionViewController: UIViewController {
    
    //MARK:- IBoutlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: Properties
    var refreshControl: UIRefreshControl?
    let detailUrl = "movies?order_type="
    let cellIdentifier = "collectionViewCell"
    
    @IBAction func touchUpSettingsButton() {
        let alertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: .actionSheet)
        let reservationRateAction = UIAlertAction(title: "예매율", style: .default, handler: { _ in
            Singleton.shared.orderType = "0"
            self.requestMovies(orderType: Singleton.shared.orderType)
        })
        let curationAction = UIAlertAction(title: "큐레이션", style: .default, handler: { _ in
            Singleton.shared.orderType = "1"
            self.requestMovies(orderType: Singleton.shared.orderType)
        })
        let releaseDateAction = UIAlertAction(title: "개봉일", style: .default, handler: { _ in
            Singleton.shared.orderType = "2"
            self.requestMovies(orderType: Singleton.shared.orderType)
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(reservationRateAction)
        alertController.addAction(curationAction)
        alertController.addAction(releaseDateAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestMovies(orderType: Singleton.shared.orderType)
    }
}

extension MovieListCollectionViewController {
    func setup() {
        collectionView.register(UINib(nibName: "MovieListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        addRefreshControl()
    }
    
    func requestMovies(orderType: String) {
        API.shared.requestMovies(orderType: orderType) { response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let response = response else { return }
            Singleton.shared.movies = response.movies
            DispatchQueue.main.async { [weak self] in
                self?.setNavigationTitle(orderType: Singleton.shared.orderType)
                self?.collectionView.reloadData()
            }
        }
    }
    
    func setNavigationTitle(orderType: String) {
        switch orderType {
        case "0":
            navigationItem.title = "예매율순"
        case "1":
            navigationItem.title = "큐레이션"
        case "2":
            navigationItem.title = "개봉일순"
        default:
            navigationItem.title = ""
            print("unexpected input value")
        }
    }
}

extension MovieListCollectionViewController {
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(movieListRefresh), for: .valueChanged)
        if let refreshControl = refreshControl {
            collectionView.addSubview(refreshControl)
        }
    }
    
    @objc func movieListRefresh() {
        refreshControl?.endRefreshing()
        requestMovies(orderType: Singleton.shared.orderType)
    }
}

extension MovieListCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Singleton.shared.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailInfoVC") as? MovieDetailInfoViewController else {
            return
        }
        viewController.id = Singleton.shared.movies[indexPath.item].id
        viewController.navigationItem.title = Singleton.shared.movies[indexPath.row].title
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MovieListCollectionViewCell else {
            return UICollectionViewCell()
        }
        let movie = Singleton.shared.movies[indexPath.item]
        cell.titleLabel.text = movie.title
        cell.detailInfoLabel.text = "\(movie.grade)위(\(movie.userRating)) / \(movie.reservationRate)%"
        cell.releaseDateLabel.text = movie.date
        switch movie.grade {
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
            if let imageURL = URL(string: movie.thumb) {
                do {
                    let imageData = try Data.init(contentsOf: imageURL)
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        cell.posterImageView.image = image
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        return cell
    }
}
