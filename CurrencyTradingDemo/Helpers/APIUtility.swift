//
//  APIUtility.swift
//  CurrencyTradingDemo
//
//  Created by Parth on 11/12/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import Foundation
typealias ReturnObjectType = (AnyObject?, Data?)

struct APIUtility {

    static func post(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: ReturnObjectType) -> ()) {
        dataTask(request: request, method: "POST", completion: completion)
    }

    static func put(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: ReturnObjectType) -> ()) {
        dataTask(request: request, method: "PUT", completion: completion)
    }

    static func get(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: ReturnObjectType) -> ()) {
        dataTask(request: request, method: "GET", completion: completion)
    }

    private static func dataTask(request: NSMutableURLRequest, method: String, completion: @escaping (_ success: Bool, _ object: ReturnObjectType) -> ()) {
        request.httpMethod = method

        let session = URLSession(configuration: URLSessionConfiguration.default)

        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    completion(true, (json as AnyObject?, data))
                } else {
                    completion(false, (json as AnyObject?, data))
                }
            }
            else{
                completion(false, (nil, nil))
            }
        }.resume()
    }
}
