//
//  OperatorController.swift
//  FoodTruck
//
//  Created by Sammy Alvarado on 6/25/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import Foundation
import CoreData

enum operatorNetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
}

let baseURL1 = URL(string: "https://foodtruck-71a6c.firebaseio.com/")!

class OperatorController {

    typealias CompletionHandler = (Result<Bool, operatorNetworkError>) -> Void

    init() {
        fetchTasksFromServer()
    }

    // Fetch Tasks from firebase
    func fetchTasksFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL1.appendingPathExtension("json")

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
                let operatorRepresentations = Array(try JSONDecoder().decode([String : OperatorRepresentation].self, from: data).values)

                try self.updateOperator(with: operatorRepresentations)
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
    func sendTaskToServer(operatoR: Operator, completion: @escaping CompletionHandler = { _ in }) {

        guard let uuid = operatoR.identifier else {
            completion(.failure(.noIdentifier))
            return
        }

        // https://tasks-3f211.firebaseio.com/[unique identifier here].json
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")

        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"

        do {
            guard let representation = operatoR.operatorRepresentation else {
                completion(.failure(.noRep))
                return
            }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding task \(operatoR): \(error)")
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
    private func updateOperator(with representations: [OperatorRepresentation]) throws {
        let context = CoreDataStack.shared.container.newBackgroundContext()
        // Array of UUIDs
        let identifiersToFetch = representations.compactMap({ UUID(uuidString: $0.identifier )})

        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var tasksToCreate = representationsByID

        let fetchRequest: NSFetchRequest<Operator> = Operator.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        context.perform {
            do {
                let existingTasks = try context.fetch(fetchRequest)

                // For already existing tasks
                for operators in existingTasks {
                    guard let id = operators.identifier,
                        let representation = representationsByID[id] else { continue }
                    self.update(operators: operators, with: representation)
                    tasksToCreate.removeValue(forKey: id)
                }

                // For new tasks
                for representation in tasksToCreate.values {
                    Operator(operatorRepresentation: representation, context: context)
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

    private func update(operators: Operator, with representation: OperatorRepresentation) {
        operators.username = representation.username
        operators.password = representation.password
//        operators.trucksOwned = representation.trucksOwned
    }


    func deleteTaskFromServer(_ operators: Operator, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = operators.identifier else {
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
