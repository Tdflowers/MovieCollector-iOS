//
//  Cache+.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/31/20.
//

import Foundation

final class Cache<Key: Hashable, Value> {
    private let wrapped = NSCache<WrappedKey, Entry>()
    private let dateProvider: () -> Date
    private let entryLifetime: TimeInterval
    private let keyTracker = KeyTracker()

        init(dateProvider: @escaping () -> Date = Date.init,
             entryLifetime: TimeInterval = 12 * 60 * 60,
             maximumEntryCount: Int = 50) {
            self.dateProvider = dateProvider
            self.entryLifetime = entryLifetime
            wrapped.countLimit = maximumEntryCount
            wrapped.delegate = keyTracker
        }

//    func insert(_ value: Value, forKey key: Key) {
//        let date = dateProvider().addingTimeInterval(entryLifetime)
//        let entry = Entry(key: key, value: value, expirationDate: date)
//        keyTracker.keys.insert(key)
//        wrapped.setObject(entry, forKey: WrappedKey(key))
//    }

//    func value(forKey key: Key) -> Value? {
//        guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
//            return nil
//        }
//
//        guard dateProvider() < entry.expirationDate else {
//            // Discard values that have expired
//            removeValue(forKey: key)
//            return nil
//        }
//
//        return entry.value
//    }

    func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
    }
}

extension Cache {
    fileprivate subscript(key: Key) -> Entry? {
        get { return entry(forKey: key) }
        set { guard let value = newValue else {
                removeValue(forKey: key)
                return
            }

            insert(value)
        }
    }
}

extension Cache.Entry: Codable where Key: Codable, Value: Codable {}

extension Cache: Codable where Key: Codable, Value: Codable {
    convenience init(from decoder: Decoder) throws {
        self.init()

        let container = try decoder.singleValueContainer()
        let entries = try container.decode([Entry].self)
        entries.forEach(insert)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(keyTracker.keys.compactMap(entry))
    }
    
    func saveToDisk(
        withName name: String,
        using fileManager: FileManager = .default
    ) throws {
        let folderURLs = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )

        let fileURL = folderURLs[0].appendingPathComponent(name + ".cache")
        let data = try JSONEncoder().encode(self)
        try data.write(to: fileURL)
    }
}

private extension Cache {
    final class WrappedKey: NSObject {
        let key: Key

        init(_ key: Key) { self.key = key }

        override var hash: Int { return key.hashValue }

        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }

            return value.key == key
        }
    }
    
    func entry(forKey key: Key) -> Entry? {
        guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
            return nil
        }

        guard dateProvider() < entry.expirationDate else {
            removeValue(forKey: key)
            return nil
        }

        return entry
    }

    func insert(_ entry: Entry) {
        wrapped.setObject(entry, forKey: WrappedKey(entry.key))
        keyTracker.keys.insert(entry.key)
    }
    
    final class Entry {
        let key: Key
        let value: Value
        let expirationDate: Date

        init(key: Key, value: Value, expirationDate: Date) {
            self.key = key
            self.value = value
            self.expirationDate = expirationDate
        }
    }
    
    final class KeyTracker: NSObject, NSCacheDelegate {
        var keys = Set<Key>()

        func cache(_ cache: NSCache<AnyObject, AnyObject>,
                   willEvictObject object: Any) {
            guard let entry = object as? Entry else {
                return
            }

            keys.remove(entry.key)
        }
    }
    
}
