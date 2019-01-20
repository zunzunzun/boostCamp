//
//  APIResponse.swift
//  BoxOffice
//
//  Created by Presto on 19/01/2019.
//  Copyright © 2019 zunzun. All rights reserved.
//

struct APIResponse: Codable {
    let orderType: Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case movies
        case orderType = "order_type"
    }
}
