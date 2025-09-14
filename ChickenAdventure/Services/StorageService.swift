import Foundation
import UIKit

protocol StorageServiceProtocol {
    func save<T: Codable>(_ value: T, forKey key: String)
    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T?
    func saveData(_ data: Data, forKey key: String)
    func loadData(forKey key: String) -> Data?
    func remove(forKey key: String)
    func saveBool(_ value: Bool, forKey key: String)
    func loadBool(forKey key: String) -> Bool
}

final class UserDefaultsStorageService: StorageServiceProtocol {
    private let userDefaults = UserDefaults.standard
    
    func save<T: Codable>(_ value: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            userDefaults.set(data, forKey: key)
        } catch {
            print("Failed to save \(key): \(error)")
        }
    }
    
    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("Failed to load \(key): \(error)")
            return nil
        }
    }
    
    func saveData(_ data: Data, forKey key: String) {
        userDefaults.set(data, forKey: key)
    }
    
    func loadData(forKey key: String) -> Data? {
        return userDefaults.data(forKey: key)
    }
    
    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    func saveBool(_ value: Bool, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    func loadBool(forKey key: String) -> Bool {
        return userDefaults.bool(forKey: key)
    }
}
