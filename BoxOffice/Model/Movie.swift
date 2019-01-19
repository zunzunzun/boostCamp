//
//  Movie.swift
//  BoxOffice
//
//  Created by Presto on 19/01/2019.
//  Copyright © 2019 zunzun. All rights reserved.
//

struct Movie: Codable {
    let title: String
    let date: String
    let thumb: String
    let reservationGrade: Int
    let userRating: Double
    let grade: Int
    let reservationRate: Double
    let id: String
    
    var imageString: String {
        switch grade {
        case 0:
            return "icAllAges"
        default:
            return "ic\(grade)"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case title, date, thumb, grade, id
        case reservationGrade = "reservation_grade"
        case userRating = "user_rating"
        case reservationRate = "reservation_rate"
    }
}
