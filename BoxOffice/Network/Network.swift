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
            session.finishTasksAndInvalidate()
        }
        task.resume()
    }
    
    class func fetchImage(_ url: URL, completion: @escaping (Data?, Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let imageData = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    completion(imageData, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
    }
}
