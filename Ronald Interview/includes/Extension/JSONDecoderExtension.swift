//
//  JSONDecoderExtension.swift
//  Ronald Interview
//
//  Created by Ronald Kwok on 31/3/2019.
//  Copyright © 2019 Ronald Kwok. All rights reserved.
//

import Foundation

extension JSONDecoder {
    
    // MARK: - Public
    open func decode<T>(_ type: T.Type, from json: [String: Any]) -> T? where T: Decodable {
        let correctedJSON = JSONSerialization.isValidJSONObject(json) ? json : JSONDecoder.correctDict(json)
        dateDecodingStrategy = .iso8601
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: correctedJSON, options: [])
            let decodable = try decode(type, from: jsonData)
            return decodable
        } catch DecodingError.dataCorrupted(let context) {
            print("Key: \(context.codingPath.reduce("", { "\($1) \($0)" }))\nError: " + context.debugDescription)
        } catch DecodingError.keyNotFound(_, let context) {
            print("Key: \(context.codingPath.reduce("", { "\($1) \($0)" }))\nError: " + context.debugDescription)
        } catch DecodingError.typeMismatch(_, let context) {
            print("Key: \(context.codingPath.reduce("", { "\($1) \($0)" }))\nError: " + context.debugDescription)
        } catch DecodingError.valueNotFound(_, let context) {
            print("Key: \(context.codingPath.reduce("", { "\($1) \($0)" }))\nError: " + context.debugDescription)
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    // MARK: - Helpers
    private static func correctDict(_ input: [String: Any]) -> [String: Any] {
        var output = [String: Any]()
        
        for (key, value) in input {
            if let dict = value as? [String: Any] {
                output[key] = JSONDecoder.correctDict(dict)
            } else if let array = value as? [Any] {
                output[key] = JSONDecoder.correctArray(array)
            } else if let date = value as? Date {
                let formatter = ISO8601DateFormatter()
                output[key] = formatter.string(from: date)
            } else {
                output[key] = value
            }
        }
        
        return output
    }
    
    private static func correctArray(_ input: [Any]) -> [Any] {
        var output = [Any]()
        
        for value in input {
            if let dict = value as? [String: Any] {
                output.append(JSONDecoder.correctDict(dict))
            } else if let array = value as? [Any] {
                output.append(JSONDecoder.correctArray(array))
            } else if let date = value as? Date {
                let formatter = ISO8601DateFormatter()
                output.append(formatter.string(from: date))
            } else {
                output.append(value)
            }
        }
        
        return output
    }
}
