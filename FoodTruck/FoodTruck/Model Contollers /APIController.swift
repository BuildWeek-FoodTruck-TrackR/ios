//
//  APIController.swift
//  FoodTruck
//
//  Created by Kevin Stewart on 6/26/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError(Error)
    case noData
    case decodingError
}

class APIController {

    typealias CompletionHandler = (Error?) -> Void
    init() {
        fetchTrucksFromServer()
    }

    private let baseUrl = URL(string: "https://foodtruck-71a6c.firebaseio.com/")!
    func signUp(with userRep: UserRep, completion: @escaping (Error?) -> Void) {
        let identifierString = userRep.identifier
        let signUpUrl = baseUrl.appendingPathComponent("users")
            .appendingPathComponent(identifierString!)
            .appendingPathExtension("json")
        var request = URLRequest(url: signUpUrl)
        request.httpMethod = HTTPMethod.put.rawValue
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(userRep)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "",
                                   code: response.statusCode,
                                   userInfo: nil))
                return
            }
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }

    func signIn(with userRep: UserRep, completion: @escaping (Error?) -> Void) {
        let loginUrl = baseUrl.appendingPathComponent("users").appendingPathExtension("json")
        var request = URLRequest(url: loginUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "",
                                   code: response.statusCode,
                                   userInfo: nil))
                return
            }
            if let error = error {
                completion(error)
                return
            }
            guard let data = data else {
                completion(NSError())
                return
            }
            let decoder = JSONDecoder()
            do {
                let userReps = Array(try decoder.decode([String: UserRep].self, from: data).values)
//                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                print("JSON response = \(json)")
                for potentialUser in userReps {
                    if potentialUser.username == userRep.username && potentialUser.password == userRep.password {
                        print("Matching user found: \(potentialUser)")
                    }
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }

    func sendTruckToServer(truck: Truck, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = truck.identifier ?? UUID()
        let requestURL = baseUrl.appendingPathComponent("trucks")
            .appendingPathComponent(uuid.uuidString)
            .appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        print("\(requestURL)")
        request.httpMethod = "PUT"
        do {
            guard var representation = truck.truckRep else {
                print("Representation is not equal to truck.truckRep")
                completion(NSError())
                return
            }
            representation.identifier = uuid.uuidString
            truck.identifier = uuid
            try CoreDataStack.shared.save()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding task \(truck): \(error)")
            DispatchQueue.main.async {
                completion(error)
            }
            return
        }
        URLSession.shared.dataTask(with: request) { _, _, error in
            print("Inside of url session")
            if let error = error {
                print("Error PUTting truck to server: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            DispatchQueue.main.async {
                print("Success")
                completion(nil)
            }
        }.resume()
    }

    func fetchTrucksFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseUrl.appendingPathComponent("trucks")
        .appendingPathExtension("json")

        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                print("Error fetching tasks: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }

            guard let data = data else {
                print("No data return by data task")
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }

            do {
                let truckReps = Array(try JSONDecoder().decode([String: TruckRepresentation].self, from: data).values)
                try self.updateTrucks(with: truckReps)
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                print("Error decoding or storing task representations: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }.resume()
    }

    private func updateTrucks(with representations: [TruckRepresentation]) throws {
        let trucksWithID = representations.filter { $0.identifier != nil }
        let identifiersToFetch = trucksWithID.compactMap { UUID(uuidString: $0.identifier) }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, trucksWithID))
        var trucksToCreate = representationsByID

        let fetchRequest: NSFetchRequest<Truck> = Truck.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)

        let context = CoreDataStack.shared.container.newBackgroundContext()

        context.perform {
            do {
                let existingTasks = try context.fetch(fetchRequest)

                for truck in existingTasks {
                    guard let identifier = truck.identifier,
                        let representation = representationsByID[identifier] else { continue }
                    self.update(truck: truck, with: representation)
                    trucksToCreate.removeValue(forKey: identifier)
                }

                for representation in trucksToCreate.values {
                    Truck(truckRep: representation, context: context)
                }
            } catch {
                print("Error fetching tasks for UUIDs: \(error)")
            }
        }

        try CoreDataStack.shared.save(context: context)
    }
    private func update(truck: Truck, with representation: TruckRepresentation) {
        truck.name = representation.name
        truck.hrsOfOps = representation.hrsOfOps
        truck.contactInfo = representation.contactInfo
        truck.location = representation.location
        truck.menu = representation.menu
    }
}
