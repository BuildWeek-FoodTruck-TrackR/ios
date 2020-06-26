//
//  Truck+Convenience.swift
//  FoodTruck
//
//  Created by Sammy Alvarado on 6/23/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import Foundation
import CoreData

extension Truck {

    // Computed property to get representation of a Task
    var menuRepresentation: TruckRepresentation? {
        return TruckRepresentation(cuisineType: cuisineType,
                                  imageOfTruck: imageOfTruck,
                                  customerRatings: customerRatings,
                                  customerRatingAvg: customerRatingAvg)
    }

    @discardableResult convenience init(cuisineType: String?,
                                        imageOfTruck: String?,
                                        customerRatings: Double,
                                        customerRatingAvg: Double,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.cuisineType = cuisineType
        self.imageOfTruck = imageOfTruck
        self.customerRatings = customerRatings
        self.customerRatingAvg = customerRatingAvg
    }


//     Initializer to convert representation into Task
    @discardableResult convenience init?(truckRepresentation: TruckRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        self.init(cuisineType: truckRepresentation.cuisineType,
                  imageOfTruck: truckRepresentation.imageOfTruck,
                  customerRatings: truckRepresentation.customerRatings,
                  customerRatingAvg: truckRepresentation.customerRatingAvg,
                  context: context)
    }
}
