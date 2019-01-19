//
//  NSObject+.swift
//  BoxOffice
//
//  Created by Presto on 20/01/2019.
//  Copyright © 2019 zunzun. All rights reserved.
//

import Foundation

extension NSObject {
    static var description: String {
        return description().components(separatedBy: ".").last ?? ""
    }
}
