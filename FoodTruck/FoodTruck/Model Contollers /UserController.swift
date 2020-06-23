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
                let userRepresentations = Array(try JSONDecoder().decode([String : UserRepresentation].self, from: data).values)

                try self.updateTasks(with: userRepresentations)
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
    func sendTaskToServer(user: User, completion: @escaping CompletionHandler = { _ in }) {

//        guard let uuid = task.identifier else {
//            completion(.failure(.noIdentifier))
//            return
//        }

        // https://tasks-3f211.firebaseio.com/[unique identifier here].json
        let requestURL = baseURL.appendingPathExtension("json")  // .appendingPathComponent(uuid.uuidString)

        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"

        do {
            guard let representation = user.userRepresentation else {
                completion(.failure(.noRep))
                return
            }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding task \(user): \(error)")
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
    private func updateTasks(with representations: [UserRepresentation]) throws {
        let context = CoreDataStack.shared.container.newBackgroundContext()
        // Array of UUIDs
        let identifiersToFetch = representations.compactMap({ UUID(uuidString: $0.identifier )})

        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var tasksToCreate = representationsByID

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        context.perform {
            do {
                let existingTasks = try context.fetch(fetchRequest)

//                 For already existing tasks
                for task in existingTasks {
                    guard let id = User.identifier,
                        let representation = representationsByID[id] else { continue }
                    self.update(task: task, with: representation)
                    tasksToCreate.removeValue(forKey: id)
                }

                // For new tasks
                for representation in tasksToCreate.values {
                    Task(userRepresentation: representation, context: context)
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

    private func update(user: User, with representation: UserRepresentation) {
        user.username = representation.username
        user.password = representation.password
    }


    func deleteTaskFromServer(_ user: User, completion: @escaping CompletionHandler = { _ in }) {
//        guard let uuid = task.identifier else {
//            completion(.failure(.noIdentifier))
//            return
//        }

        let requestURL = baseURL.appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response!)
            completion(.success(true))
        }.resume()
    }
}
