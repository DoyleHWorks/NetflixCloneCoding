//
//  Video.swift
//  NetflixClone
//
//  Created by t0000-m0112 on 2024-12-24.
//

import Foundation

struct VideoResponse: Codable {
    let results: [Video]
}

struct Video: Codable {
    let key: String
    let site: String
    let type: String
}
