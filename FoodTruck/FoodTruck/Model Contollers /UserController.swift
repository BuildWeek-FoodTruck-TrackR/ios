//
//  UserController.swift
//  FoodTruck
//
//  Created by Sammy Alvarado on 6/19/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import Foundation
import CoreData

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
}

let baseURL = URL(string: "https://foodtruck-71a6c.firebaseio.com/")!

class UserController {

    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void

    init() {
        fetchTasksFromServer()
    }

    // Fetch Tasks from firebase
    func fetchTasksFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")

        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("Error fetching tasks: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }


            guard let data = data else {
                print("No data returned by data task")
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }

            do {
                let dinerRepresentations = Array(try JSONDecoder().decode([String : DinerRepresentation].self, from: data).values)

                try self.updateTasks(with: dinerRepresentations)
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch {
                print("Error decoding task representations: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.noDecode))
                }
                return
            }
        }.resume()
    }

    // Send Task Representation to Firebase!
    func sendTaskToServer(diner: Diner, completion: @escaping CompletionHandler = { _ in }) {

        guard let uuid = diner.identifier else {
            completion(.failure(.noIdentifier))
            return
        }

        // https://tasks-3f211.firebaseio.com/[unique identifier here].json
        let requestURL = baseURL.appendingPathExtension("json").appendingPathComponent(uuid.uuidString)

        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"

        do {
            guard let representation = diner.dinerRepresentation else {
                completion(.failure(.noRep))
                return
            }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding task \(diner): \(error)")
            completion(.failure(.noEncode))
            return
        }

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error PUTting task to server: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }

            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }

    // Update/Create Tasks with Representations
    private func updateTasks(with representations: [DinerRepresentation]) throws {
        let context = CoreDataStack.shared.container.newBackgroundContext()
        // Array of UUIDs
        let identifiersToFetch = representations.compactMap({ UUID(uuidString: $0.identifier )})

        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var tasksToCreate = representationsByID

        let fetchRequest: NSFetchRequest<Diner> = Diner.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        context.perform {
            do {
                let existingDiners = try context.fetch(fetchRequest)

//                 For already existing tasks
                for diner in existingDiners {
                    guard let id = diner.identifier,
                        let representation = representationsByID[id] else { continue }
                    self.update(diner: diner, with: representation)
                    tasksToCreate.removeValue(forKey: id)
                }

                // For new tasks
                for representation in tasksToCreate.values {
                    Diner(dinerRepresentation: representation, context: context)
                }
            } catch {
                print("error fetching tasks for UUIDs: \(error)")
            }
            do {

                try CoreDataStack.shared.save(context: context)
            } catch {
                print("error saving)")
            }
        }

    }

    private func update(diner: Diner, with representation: DinerRepresentation) {
        diner.username = representation.username
        diner.password = representation.password
    }

    func deleteTaskFromServer(_ diner: Diner, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = diner.identifier else {
            completion(.failure(.noIdentifier))
            return
        }

        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response!)
            completion(.success(true))
        }.resume()
    }
}
