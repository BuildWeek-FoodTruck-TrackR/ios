//
//  User+Convenience.swift
//  FoodTruck
//
//  Created by Sammy Alvarado on 6/18/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import Foundation
import CoreData

extension User {
    var userRepresentation: UserRepresentation? {
        guard let username = username,
            let password = password else { return nil }

        return UserRepresentation(username: username,
                                  password: password)
    }

    @discardableResult convenience init(username: String,
                                    password: String,
                                    context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.username = username
        self.password = password
    }


    @discardableResult convenience init?( userRepresentation: UserRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(username:  userRepresentation.username,
                  password:  userRepresentation.password,
                  context: context)
    }
}
