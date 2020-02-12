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

    // MARK:  Singleton
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
    private let realm: Realm = {
        do {
            let realm = try Realm()
            print("realm ok!")
            return realm
        } catch {
            fatalError("Realm not exist! \(error.localizedDescription)")
        }
    }()

    private var notificationToken: NotificationToken?
}

extension RealmManager {

    // MARK: Notifications
    func setupObserve<T: Object>(_ type: T.Type, completion: @escaping Completion) {
        notificationToken = realm.objects(type).observe({ change in
            switch change {
            case .error(let error):
                completion(false, error.localizedDescription)
            default:
                completion(true, "")
            }
        })
    }

    /// invalidate
    func invalidateNotificationToken() {
        notificationToken?.invalidate()
    }

    /// Add object to the Realm
    func addObject<T: Object>(object: T, completion: @escaping Completion) {
        do {
            try realm.write {
                realm.create(T.self, value: object, update: .all)
                completion(true, "")
            }
        } catch {
            completion(false, error.localizedDescription)
        }
    }

    /// Delete  object from the Realm
    func deleteObject<T: Object, KeyType>(object: T, forPrimaryKey key: KeyType, completion: @escaping Completion) {
        do {
            try realm.write {
                if let obj = getObjectForKey(object: object, forPrimaryKey: key) {
                    realm.delete(obj)
                    completion(true, "")
                } else {
                    completion(false, "No object in Realm")
                }
            }
        } catch {
            completion(false, error.localizedDescription)
        }
    }

    /// Get all object in the Realm
    func getObjects<T: Object>(_ type: T.Type) -> [T] {
        let objects = Array(realm.objects(type))
        return objects
    }

    /// The local URL of the Realm file
    func configurationFileURL() -> URL? {
        return realm.configuration.fileURL
    }

    /// Check Realm have contains news?
    func isRealmContainsObject<T: Object, KeyType>(object: T, forPrimaryKey key: KeyType) -> Bool {
        guard getObjectForKey(object: object, forPrimaryKey: key) != nil else { return false }
        return true
    }

    /// Get objec for key
    func getObjectForKey<Element: Object, KeyType>(object: Element, forPrimaryKey key: KeyType) -> Element? {
        return realm.object(ofType: Element.self, forPrimaryKey: key)
    }

    /// Get all news for Category in the Realm
    func getNewsForCategoryInRealm(query: String) -> [News] {
        let objects = realm.objects(News.self).filter { $0.categoryNews == query }
        let ars = Array(objects)
        return ars
    }
}
