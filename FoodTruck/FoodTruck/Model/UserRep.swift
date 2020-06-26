//
//  User.swift
//  FoodTruck
//
//  Created by Kevin Stewart on 6/26/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import Foundation

struct UserRep: Codable {
    let username: String
    let password: String
    let identifier: String?
}
