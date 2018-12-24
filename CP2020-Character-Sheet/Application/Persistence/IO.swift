//
//  IO.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/23/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Serial disk operation. Handles the saving and loading of the JSONs for the character sheet.
/// File operations are synchronous.
final class IO {
    
    /// The disk operation queue
    let queue: DispatchQueue
    
    /// Creates the IO class
    ///
    /// - Parameter queue: A queue on which to operate. Operations are synchronous. By default, this is a QOS of "utility"
    init(with queue: DispatchQueue = DispatchQueue(label: "CP2020_IO", qos: .utility)) {
        self.queue = queue
    }
    
    /// Synchronously loads the specific JSON file requested
    ///
    /// - Parameters:
    ///   - file: The JSON file you want
    ///   - completion: A completion handler for the result
    func load(_ file: JSONFile, completion: (Data?, Error?) -> Void) {
        queue.sync {
            guard let url = Bundle.main.url(forResource: file.name(), withExtension: Constants.json) else {
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                completion(data, nil)
            }
            catch let error {
                completion(nil, error)
            }
        }
    }
    
    /// Synchronously saves the specific Data requested
    ///
    /// - Parameters:
    ///   - data: The data file to save
    ///   - file: The JSONFile to save it to
    ///   - completion: A completion handler for the result
    func save(_ data: Data, to file: JSONFile, completion: (Error?) -> Void) {
        queue.sync {
            guard let url = Bundle.main.url(forResource: file.name(), withExtension: Constants.json) else {
                return
            }
            
            do {
                // TODO: Safer save operation to check for space and deletion, creates backup before deleting, etc
                try FileManager.default.removeItem(at: url)
                try data.write(to: url)
                completion(nil)
            }
            catch let error {
                completion(error)
            }
        }
    }
    
    // TODO: Custom files (i.e. new Skill sets)
    
    /// Names of files commonly used with JSON operations
    ///
    /// - Skills: The Skills JSON
    /// - Edgerunner: The player Edgerunner JSON
    enum JSONFile {
        case Skills, Edgerunner
        
        func name() -> String {
            switch self {
            case .Skills:
                return Constants.skills
            case .Edgerunner:
                return Constants.edgerunner
            }
        }
    }
    
    private struct Constants {
        static let json = "json"
        static let skills = "Skills"
        static let edgerunner = "Edgerunner"
    
    }
}
