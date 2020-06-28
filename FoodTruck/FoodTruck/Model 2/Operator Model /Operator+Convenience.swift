//
//  Operator+Convenience.swift
//  FoodTruck
//
//  Created by Sammy Alvarado on 6/23/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import Foundation
import CoreData

extension Operator {

    // Computed property to get representation of a Task
    var operatorRepresentation: OperatorRepresentation? {
        guard let username = username,
            let password = password else { return nil }

        return OperatorRepresentation(identifier: identifier?.uuidString ?? "",
                                  username: username,
                                  password: password,
                                  trucksOwned: trucksOwned)
    }

    @discardableResult convenience init(identifier: UUID = UUID(),
                                        username: String,
                                        password: String,
                                        trucksOwned: String?,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.username = username
        self.password = password
        self.trucksOwned = trucksOwned
    }

    // Initializer to convert representation into Task
    @discardableResult convenience init?(operatorRepresentation: OperatorRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let identifier = UUID(uuidString: operatorRepresentation.identifier) else { return nil }

        self.init(identifier: identifier,
                  username: operatorRepresentation.username,
                  password: operatorRepresentation.password,
                  trucksOwned: operatorRepresentation.trucksOwned,
                  context: context)
    }
}
