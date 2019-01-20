//
//  API.swift
//  BoxOffice
//
//  Created by Presto on 20/01/2019.
//  Copyright © 2019 zunzun. All rights reserved.
//

import Foundation

class API {
    
    static let shared = API()
    
    func requestMovies(orderType: String, completion: @escaping (APIResponse?, Error?) -> Void) {
        guard let url = URL(string: "\(Singleton.shared.url)movies?order_type=\(orderType)") else { return }
        Network.get(url) { (data, error) in
            if let data = data {
                do {
                    let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(apiResponse, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    func requestDetailInfo(movieID id: String, completion: @escaping (MovieDetailInfo?, Error?) -> Void) {
        guard let url = URL(string: "\(Singleton.shared.url)movie?id=\(id)") else { return }
        Network.get(url) { data, error in
            if let data = data {
                do {
                    let movieDetailInfo = try JSONDecoder().decode(MovieDetailInfo.self, from: data)
                    completion(movieDetailInfo, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    func requestComment(movieID id: String, completion: @escaping (CommentsList?, Error?) -> Void) {
        guard let url = URL(string: "\(Singleton.shared.url)comments?movie_id=\(id)") else { return }
        Network.get(url) { data, error in
            if let data = data {
                do {
                    let commentList = try JSONDecoder().decode(CommentsList.self, from: data)
                    completion(commentList, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }
}
