//
//  CommentModel.swift
//  BoxOffice
//
//  Created by 이재은 on 20/01/2019.
//  Copyright © 2019 zunzun. All rights reserved.
//

import Foundation

/// 댓글 응답 객체
struct CommentsList: Codable {
    let movieId: String
    let comments: [Comment]
    
    enum CodingKeys: String, CodingKey {
        case comments
        case movieId = "movie_id"
    }
}

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
