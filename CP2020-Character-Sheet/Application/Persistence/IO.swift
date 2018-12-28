//
//  IO.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/23/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

enum IOError: Error {
    case NoSuchFile, CantAccessDocuments
}

/// Serial disk operation. Handles the saving and loading of the JSONs for the character sheet.
/// File operations are synchronous.
final class IO {
    
    /// The disk operation queue
    let queue: DispatchQueue
    private(set) var customSkillsExist = false
    
    private let fileManager = FileManager.default
    
    /// Creates the IO class
    ///
    /// - Parameter queue: A queue on which to operate. Operations are synchronous. By default, this is a QOS of "utility"
    init(with queue: DispatchQueue = DispatchQueue(label: "CP2020_IO", qos: .utility)) {
        self.queue = queue
        
        // This call will happen synchronously on main on purpose.
        // This should be checked before any other save/load actions take place.
        self.customSkillsExist = expectedURL(for: .CustomSkills) != nil
    }
    
    /// Synchronously loads the specific JSON file requested from the documents folder or from the bundle.
    ///
    /// - Parameters:
    ///   - file: The JSON file you want
    ///   - completion: A completion handler for the result
    func load(_ file: JSONFile, completion: (Data?, Error?) -> Void) {
        queue.sync {
            guard let url = expectedURL(for: file) else {
                completion(nil, IOError.NoSuchFile)
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
    
    /// Synchronously saves the specific Data requested to the documents folder.
    ///
    /// - Parameters:
    ///   - data: The data file to save
    ///   - file: The JSONFile to save it to
    ///   - completion: A completion handler for the result
    func save(_ data: Data, to file: JSONFile, completion: (Error?) -> Void) {
        queue.sync {
            guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
                let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
                completion(IOError.CantAccessDocuments)
                return
            }
            var contents = [URL]()
            let filename = "\(file.name()).\(file.extension())"
            
            do {
                contents = try fileManager.contentsOfDirectory(at: documents, includingPropertiesForKeys: nil)

                
                if contents.isEmpty {
                    try data.write(to: documents.appendingPathComponent(filename))
                    
                    if file == .CustomSkills {
                        customSkillsExist = true
                    }
                }
                else if let existingFile = contents.first(where: { $0.lastPathComponent == filename }) {
                    try overwrite(existingFile: existingFile,
                                  with: data,
                                  filename: filename,
                                  documentsDirectory: documents,
                                  supportDirectory: support)
                }
            }
            catch let error {
                completion(error)
                return
            }
        }
    }
    
    /// Ovewrite method
    private func overwrite(existingFile: URL, with data: Data, filename: String, documentsDirectory documents: URL, supportDirectory support: URL) throws {
        let tempFilename = "\(filename)-\(Date().timeIntervalSince1970)-temp)"
        let tempFile = support.appendingPathComponent(tempFilename)
        
        try fileManager.copyItem(at: existingFile, to: tempFile)
        try fileManager.removeItem(at: existingFile)
        
        try data.write(to: documents.appendingPathComponent(filename))
        
        try fileManager.removeItem(at: tempFile)
    }
    
    /// Returns the expected url for the JSON file requested
    ///
    /// - Parameter file: The file requested
    /// - Returns: The URL, if the file exists
    private func expectedURL(for file: JSONFile) -> URL? {
        switch file {
        case .DefaultSkills:
            return Bundle.main.url(forResource: file.name(), withExtension: file.extension())
        default:
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
                .appendingPathComponent("\(file.name()).\(file.extension())")
            
            if fileManager.fileExists(atPath: url?.absoluteString ?? "") {
                return url
            }
            
            return nil
        }
    }
        
    /// Names of files commonly used with JSON operations
    ///
    /// - Skills: The Skills JSON
    /// - Edgerunner: The player Edgerunner JSON
    enum JSONFile {
        case DefaultSkills, Edgerunner, CustomSkills
        
        func name() -> String {
            switch self {
            case .DefaultSkills:
                return Constants.skills
            case .CustomSkills:
                return Constants.customSkills
            case .Edgerunner:
                return Constants.edgerunner
            }
        }
        
        func `extension`() -> String {
            return Constants.json
        }
    }
    
    private struct Constants {
        static let json = "json"
        static let skills = "Skills"
        static let customSkills = "CustomSkills"
        static let edgerunner = "Edgerunner"
    }
}
