//
//  MovieDetailInfo.swift
//  BoxOffice
//
//  Created by Presto on 19/01/2019.
//  Copyright © 2019 zunzun. All rights reserved.
//

import Foundation

struct MovieDetailInfo: Codable {
    let audience: Int
    let actor: String
    let duration: Int
    let director: String
    let synopsis: String
    let genre: String
    let grade: Int
    let image: String
    let reservationGrade: Int
    let title: String
    let reservationRate: Double
    let userRating: Double
    let date: String
    let id: String
    
    var imageString: String {
        switch grade {
        case 0:
            return "icAllAges"
        default:
            return "ic\(grade)"
        }
    }
    
    var audienceString: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: audience))
    }
    
    enum CodingKeys: String, CodingKey {
        case audience, actor, duration, director, synopsis, genre, grade, image, title, date, id
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
}
