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
}
