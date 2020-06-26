//
//  User+convenience.swift
//  FoodTruck
//
//  Created by Kevin Stewart on 6/26/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import Foundation
import CoreData

extension User {
    var userRep: UserRep? {
        guard let username = username,
            let password = password else { return nil }
        return UserRep(username: username,
                       password: password,
                       identifier: id?.uuidString)
    }

    @discardableResult convenience init(username: String,
                                        password: String,
                                        id: UUID = UUID(),
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.username = username
        self.password = password
        self.id = id
    }

    @discardableResult
    convenience init?(userRep:                                         UserRep,
                      context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let idString = userRep.identifier,
            let id = UUID(uuidString: idString) else { return nil }

        self.init(username: userRep.username,
                  password: userRep.password,
                  id: id,
                  context: context)
    }
}
