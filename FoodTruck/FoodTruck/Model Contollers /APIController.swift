//
//  APIController.swift
//  FoodTruck
//
//  Created by Kevin Stewart on 6/26/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import Foundation
import UIKit

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

    private let baseUrl = URL(string: "https://foodtruck-71a6c.firebaseio.com/")!
    func signUp(with userRep: UserRep, completion: @escaping (Error?) -> Void) {
        let identifierString = userRep.identifier
        let signUpUrl = baseUrl.appendingPathComponent("users").appendingPathComponent(identifierString!).appendingPathExtension("json")
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
        let requestURL = baseUrl.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        do {
            guard var representation = truck.truckRep else {
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
            if let error = error {
                print("Error PUTting truck to server: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
}
