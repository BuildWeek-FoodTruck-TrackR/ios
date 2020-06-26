//
//  OperatorRepresentation.swift
//  FoodTruck
//
//  Created by Sammy Alvarado on 6/23/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import Foundation

struct OperatorRepresentation: Codable {
    var identifier: String
    var username: String
    var password: String
    var trucksOwned: String?
}
