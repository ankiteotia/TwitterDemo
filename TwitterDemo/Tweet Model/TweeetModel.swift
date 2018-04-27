//
//  AppDelegate.swift
//  TweeetModel
//
//  Created by Ankit Teotia on 18/9/18.
//  Copyright © 2018 Ankit Teotia. All rights reserved.
//

import Foundation
struct TweeetModel : Codable {
    let statuses : [Statuses]?

	enum CodingKeys: String, CodingKey {
		case statuses = "statuses"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		statuses = try values.decodeIfPresent([Statuses].self, forKey: .statuses)
	}
}

struct Statuses : Codable {    
    let geo : [Geo]?

    enum CodingKeys: String, CodingKey {
        case geo = "geo"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        geo = try values.decodeIfPresent([Geo].self, forKey: .geo)
    }
}

struct Geo : Codable {
    let type : String?
    let coordinates : [Double]?
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case coordinates = "coordinates"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        coordinates = try values.decodeIfPresent([Double].self, forKey: .coordinates)
    }
}
