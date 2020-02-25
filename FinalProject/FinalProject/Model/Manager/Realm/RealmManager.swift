//
//  RealmManager.swift
//  FinalProject
//
//  Created by TranVanTien on 2/8/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmManager {

    // MARK: singleton
    private static var shareRealmManager: RealmManager = {
        let shareRealmManager = RealmManager()
        return shareRealmManager
    }()

    static func shared() -> RealmManager {
        return shareRealmManager
    }

    /// init
    private init() { }

    /// config Realm
    private let realm: Realm? = {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { _, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if oldSchemaVersion < 1 {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config

        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        let realm = try? Realm()

        return realm
    }()
}

extension RealmManager {

    // MARK: Notifications
    func setupObserve<T: Object>(_ type: T.Type, completion: @escaping Completion) -> NotificationToken? {
        guard let realm = realm else { return nil }
        let notificationToken = realm.objects(type).observe({ change in
            switch change {
            case .error(let error):
                completion(false, error.localizedDescription)
            default:
                completion(true, "")
            }
        })

        return notificationToken
    }

    /// invalidate
    func invalidateNotificationToken(token: NotificationToken?) {
        token?.invalidate()
    }

    /// Add object to the Realm
    func addObject<T: Object>(object: T, completion: @escaping Completion) {
        do {
            try realm?.write {
                realm?.create(T.self, value: object, update: .all)
                completion(true, "")
            }
        } catch {
            completion(false, error.localizedDescription)
        }
    }

    /// Delete  object from the Realm
    func deleteObject<T: Object, KeyType>(object: T, forPrimaryKey key: KeyType, completion: @escaping Completion) {
        do {
            try realm?.write {
                if let obj = getObjectForKey(object: object, forPrimaryKey: key) {
                    realm?.delete(obj)
                    completion(true, "")
                } else {
                    completion(false, "No object in Realm")
                }
            }
        } catch {
            completion(false, error.localizedDescription)
        }
    }

    /// Delete  objects  from the Realm
    func deleteObjects<T: Object, KeyType>(object: T, forPrimaryKey keys: [KeyType], completion: @escaping Completion) {
        var objectsForPKInRealm: [T] = []
        keys.forEach { key in
            if let objectForPKInRealm = getObjectForKey(object: object, forPrimaryKey: key) {
                objectsForPKInRealm.append(objectForPKInRealm)
            }
        }

        do {
            try realm?.write {
                realm?.delete(objectsForPKInRealm)
                completion(true, "")
            }
        } catch {
            completion(false, error.localizedDescription)
        }
    }

    /// Get all object in the Realm
    func getObjects<T: Object>(_ type: T.Type) -> [T] {
        guard let realm = realm else { return [] }
        let objects = Array(realm.objects(type))
        return objects
    }

    /// Get objec for key
    func getObjectForKey<Element: Object, KeyType>(object: Element, forPrimaryKey key: KeyType) -> Element? {
        return realm?.object(ofType: Element.self, forPrimaryKey: key)
    }

    /// The local URL of the Realm file
    func configurationFileURL() -> URL? {
        return realm?.configuration.fileURL
    }

    /// Check Realm have contains news?
    func isRealmContainsObject<T: Object, KeyType>(object: T, forPrimaryKey key: KeyType) -> Bool {
        guard getObjectForKey(object: object, forPrimaryKey: key) != nil else { return false }
        return true
    }

    /// Get all news for Category in the Realm
    func getNewsForCategoryInRealm(query: String) -> [News] {
        guard let realm = realm else { return [] }
        let objects = realm.objects(News.self).filter { $0.categoryNews == query }
        let ars = Array(objects)
        return ars
    }
}
