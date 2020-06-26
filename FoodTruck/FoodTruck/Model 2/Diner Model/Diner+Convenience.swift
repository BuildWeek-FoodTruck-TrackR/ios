//
//  Diner+Convenience.swift
//  FoodTruck
//
//  Created by Sammy Alvarado on 6/22/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import Foundation
import CoreData

extension Diner {

    // Computed property to get representation of a Task
    var dinerRepresentation: DinerRepresentation? {
        guard let username = username,
            let password = password else { return nil }

        return DinerRepresentation(identifier: identifier?.uuidString ?? "",
                                  username: username,
                                  password: password,
                                  favoriteTrucks: favoriteTrucks)
    }

    @discardableResult convenience init(identifier: UUID = UUID(),
                                        username: String,
                                        password: String,
                                        favoriteTrucks: String?,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.username = username
        self.password = password
        self.favoriteTrucks = favoriteTrucks
    }


    // Initializer to convert representation into Task
    @discardableResult convenience init?(dinerRepresentation: DinerRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let identifier = UUID(uuidString: dinerRepresentation.identifier) else { return nil }

        self.init(identifier: identifier,
                  username: dinerRepresentation.username,
                  password: dinerRepresentation.password,
                  favoriteTrucks: dinerRepresentation.favoriteTrucks,
                  context: context)
    }
}
