//
//  DinerRepresentation.swift
//  FoodTruck
//
//  Created by Sammy Alvarado on 6/22/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import Foundation

struct DinerRepresentation: Codable {
    var identifier: String
    var username: String
    var password: String
    var favoriteTrucks: String?
}
