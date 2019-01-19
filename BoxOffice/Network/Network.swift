//
//  Network.swift
//  BoxOffice
//
//  Created by Presto on 20/01/2019.
//  Copyright © 2019 zunzun. All rights reserved.
//

import Foundation

class Network {
    
    class func get(_ url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            completion(data, error)
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
