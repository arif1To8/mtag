//
//  UserDefaultExtension.swift
//  AddMee
//
//  Created by Abdul Wahab on 12/04/2021.
//

import Foundation

extension UserDefaults {
    func setCustomObject<T:Encodable>(_ object: T?, forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        }
    }
    
    func getCustomObject<T:Decodable>(_ key: String) -> T? {
        let defaults = UserDefaults.standard
        if let object = defaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let object = try? decoder.decode(T.self, from: object) {
                return object
            }
        }
        return nil
    }
}
