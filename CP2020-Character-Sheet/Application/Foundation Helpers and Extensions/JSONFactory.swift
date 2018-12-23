//
//  JSONFactory.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/22/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

final class JSONFactory<T: Codable> {
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    /// Decodes data into the codable object
    ///
    /// - Parameter data: Data created from a saved JSON
    /// - Returns: The inflated codable object
    func decode(with data: Data) -> T? {
        var object: T?
        do {
            object = try decoder.decode(T.self, from: data)
        }
        catch {
            // TODO: Catch this and bubble up errors
        }
        
        return object
    }
    
    /// Encodes an object into data
    ///
    /// - Parameter object: The object you wish to encode
    /// - Returns: Encoded data
    func encode(with object: T) -> Data? {
        var data: Data?
        
        do {
            data = try encoder.encode(object)
        }
        catch {
            // TODO: Catch this and bubble up errors
        }
        
        return data
    }
    
    /// Convers an object into a JSON string
    ///
    /// - Parameter object: The object to convert
    /// - Returns: UTF8 encoded JSON string
    func encodedString(from object: T) -> String? {
        guard let data = encode(with: object),
            let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return string
    }
    
    /// Decodes an object with the supplied JSON string
    ///
    /// - Parameter string: A JSON string assumed to be a valid JSON
    /// - Returns: The object, decoded.
    func decodedObject(from string: String) -> T? {
        guard let data = string.data(using: .utf8),
            let object = decode(with: data) else {
            return nil
        }
        
        return object
    }
    
}
