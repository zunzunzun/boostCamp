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
        self.present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestMovies(orderType: Singleton.shared.orderType)
    }
}

extension MovieListCollectionViewController {
    func setup() {
        self.collectionView.register(UINib(nibName: "MovieListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.cellIdentifier)
        self.addRefreshControl()
    }
    
    func requestMovies(orderType: String) {
        guard let url = URL(string: Singleton.shared.url + self.detailUrl + orderType) else {
            print("URL error!")
            return
        }
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else {
                print("data error!")
                return
            }
            do {
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                Singleton.shared.movies = apiResponse.movies
                DispatchQueue.main.async {
                    self.navigationTitleSetup(orderType: Singleton.shared.orderType)
                    self.collectionView.reloadData()
                }
                print("API Response Download Success!")
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        dataTask.resume()
    }
    
    func navigationTitleSetup(orderType: String) {
        switch orderType {
        case "0":
            self.navigationItem.title = "예매율순"
        case "1":
            self.navigationItem.title = "큐레이션"
        case "2":
            self.navigationItem.title = "개봉일순"
        default:
            self.navigationItem.title = ""
            print("unexpected input value")
        }
    }
}

extension MovieListCollectionViewController {
    func addRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.movieListRefresh), for: .valueChanged)
        if let refreshControl = self.refreshControl {
            self.collectionView.addSubview(refreshControl)
        }
    }
    
    @objc func movieListRefresh() {
        self.refreshControl?.endRefreshing()
        self.requestMovies(orderType: Singleton.shared.orderType)
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
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? MovieListCollectionViewCell else {
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
