//
//  MovieModel.swift
//  BoxOffice
//
//  Created by 이재은 on 20/01/2019.
//  Copyright © 2019 zunzun. All rights reserved.
//

import Foundation

/// 영화 리스트 응답 객체
struct APIResponse: Codable {
    let orderType: Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case movies
        case orderType = "order_type"
    }
}

struct Movie: Codable {
    let title: String
    let date: String
    let thumb: String
    let reservationGrade: Int
    let userRating: Double
    let grade: Int
    let reservationRate: Double
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case title, date, thumb, grade, id
        case reservationGrade = "reservation_grade"
        case userRating = "user_rating"
        case reservationRate = "reservation_rate"
    }
}
