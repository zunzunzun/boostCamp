//
//  MovieListTableViewController.swift
//  BoxOffice
//
//  Created by LEE JUNSANG on 2018. 12. 16..
//  Copyright © 2018년 zunzun. All rights reserved.
//

import UIKit

class MovieListTableViewController: UIViewController {
    
    //MARK:- IBoutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    var refreshControl: UIRefreshControl?
    let detailUrl = "movies?order_type="
    
    //MARK: IBAction
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

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestMovies(orderType: Singleton.shared.orderType)
    }
}

//MARK:- Setup and functions
extension MovieListTableViewController {
    func setup() {
        tableView.register(UINib(nibName: MovieListTableViewCell.description, bundle: nil), forCellReuseIdentifier: Constant.movieListTableViewCellIdentifier)
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
                self?.tableView.reloadData()
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

//MARK:- Refresh Function
extension MovieListTableViewController {
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(movieListDidRefresh), for: .valueChanged)
        if let refreshControl = refreshControl {
            tableView.refreshControl = refreshControl
        }
    }
    
    @objc func movieListDidRefresh() {
        refreshControl?.endRefreshing()
        requestMovies(orderType: Singleton.shared.orderType)
    }
}

//MARK:- Cell
extension MovieListTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Singleton.shared.movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailInfoVC") as? MovieDetailInfoViewController else {
            return
        }
        viewController.id = Singleton.shared.movies[indexPath.item].id
        viewController.navigationItem.title = Singleton.shared.movies[indexPath.row].title
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.movieListTableViewCellIdentifier, for: indexPath) as? MovieListTableViewCell else {
            return UITableViewCell()
        }
        let movie = Singleton.shared.movies[indexPath.row]
        cell.titleLabel.text = movie.title
        cell.ageImageView.image = UIImage(named: movie.imageString)
        cell.detailInfoLabel.text = "평점 : \(movie.userRating)  예매순위 : \(movie.reservationGrade)  예매율 : \(movie.reservationRate)"
        cell.releaseDateLabel.text = "개봉일 : \(movie.date)"
        OperationQueue().addOperation {
            if let imageURL = URL(string: movie.thumb) {
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
        return cell
    }
}
