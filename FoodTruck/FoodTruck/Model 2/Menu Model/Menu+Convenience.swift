//
//  Menu+Convenience.swift
//  FoodTruck
//
//  Created by Sammy Alvarado on 6/23/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import Foundation
import CoreData

extension Menu {

    // Computed property to get representation of a Task
    var menuRepresentation: MenuRepresentation? {
        return MenuRepresentation(itemPrice: itemPrice,
                                  itemPhotos: itemPhotos,
                                  itemName: itemName,
                                  itemDescription: itemDescription,
                                  customerRatings: customerRatings,
                                  customerRatingAvg: customerRatingAvg)
    }

    @discardableResult convenience init(identifier: UUID = UUID(),
                                        itemPrice: String,
                                        itemPhotos: String,
                                        itemName: String?,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.itemPrice = itemPrice
        self.itemPhotos = itemPhotos
        self.password = password
        self.trucksOwned = trucksOwned
    }

    // Initializer to convert representation into Task
    @discardableResult convenience init?(menuRepresentation: MenuRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let identifier = UUID(uuidString: menuRepresentation.identifier) else { return nil }

        self.init(identifier: identifier,
                  itemPrice: menuRepresentation.itemPrice,
                  itemPhotos: menuRepresentation.itemPhotos,
                  trucksOwned: menuRepresentation.trucksOwned,
                  context: context)
    }
}
