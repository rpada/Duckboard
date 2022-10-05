//
//  Struct.swift
//  Duckboard
//
//  Created by Brenna Pada on 10/3/22.
//

import Foundation

struct DuckResponse: Codable{
    let url: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
        case message = "message"
    }
}

