//
//  Singleton.swift
//  BoxOffice
//
//  Created by LEE JUNSANG on 2018. 12. 16..
//  Copyright © 2018년 zunzun. All rights reserved.
//

import Foundation

class Singleton {
    static let shared = Singleton()
    
    private init() { }
    
    let url = "http://connect-boxoffice.run.goorm.io/"
    var orderType: String = "0"
    var movies: [Movie] = []
}
