//
//  Comment.swift
//  BoxOffice
//
//  Created by Presto on 20/01/2019.
//  Copyright © 2019 zunzun. All rights reserved.
//

struct Comment: Codable {
    let rating: Double
    let timestamp: Double
    let writer: String
    let movieId: String
    let contents: String
    
    enum CodingKeys: String, CodingKey {
        case rating, timestamp, writer, contents
        case movieId = "movie_id"
    }
}
