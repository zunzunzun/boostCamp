//
//  CommentsList.swift
//  BoxOffice
//
//  Created by Presto on 19/01/2019.
//  Copyright © 2019 zunzun. All rights reserved.
//

struct CommentsList: Codable {
    let movieId: String
    let comments: [Comment]
    
    enum CodingKeys: String, CodingKey {
        case comments
        case movieId = "movie_id"
    }
}
