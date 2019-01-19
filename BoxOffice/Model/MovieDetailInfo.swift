//
//  MovieDetailInfo.swift
//  BoxOffice
//
//  Created by Presto on 19/01/2019.
//  Copyright © 2019 zunzun. All rights reserved.
//

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
    
    var audienceString: String {
        var value = audience
        var temp: String = ""
        while true {
            if value / 1000 == 0 {
                return "\(value % 1000)\(temp)"
            } else {
                temp = ",\(value % 1000)\(temp)"
                value = value / 1000
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case audience, actor, duration, director, synopsis, genre, grade, image, title, date, id
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
}
