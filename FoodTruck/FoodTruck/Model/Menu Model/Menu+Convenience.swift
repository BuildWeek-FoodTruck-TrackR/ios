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
                                        itemPrice: Double,
                                        itemPhotos: String?,
                                        itemName: String?,
                                        itemDescription: String?,
                                        customerRatings: Double,
                                        customerRatingAvg: Double,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.itemPrice = itemPrice
        self.itemPhotos = itemPhotos
        self.itemName = itemName
        self.itemDescription = itemDescription
        self.customerRatings = customerRatings
        self.customerRatingAvg = customerRatingAvg
    }


//     Initializer to convert representation into Task
    @discardableResult convenience init?(menuRepresentation: MenuRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        self.init(itemPrice: menuRepresentation.itemPrice,
                  itemPhotos: menuRepresentation.itemPhotos,
                  itemName: menuRepresentation.itemName,
                  itemDescription: menuRepresentation.itemDescription,
                  customerRatings: menuRepresentation.customerRatings,
                  customerRatingAvg: menuRepresentation.customerRatingAvg,
                  context: context)
    }
}
