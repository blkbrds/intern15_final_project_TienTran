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
}

extension RealmManager {

    /// Add object to the Realm
    func addObject<T: Object>(object: T, completion: @escaping Completion) {
        do {
            try realm.write {
                realm.add(object)
                completion(true, "")
            }
        } catch {
            completion(false, error.localizedDescription)
        }
    }

    /// Delete  object from the Realm
    func deleteObject<T: Object, KeyType>(object: T, forPrimaryKey key: KeyType, completion: @escaping Completion) {
        guard let objectFormRealm = realm.object(ofType: T.self, forPrimaryKey: key) else {
            completion(false, "Object no in realm")
            return
        }

        do {
            try realm.write {
                realm.delete(objectFormRealm)
                completion(true, "")
            }
        } catch {
            completion(false, error.localizedDescription)
        }
    }

    /// Get all object in the Realm
    func gets<T: Object>(_ type: T.Type) -> [T] {
        let objects = Array(realm.objects(type))
        return objects
    }

    /// getNumberArticlesForCategory
    func getCountOfObjects() -> Int {
        return 10
    }

    /// The local URL of the Realm file
    func configurationFileeURL() -> URL? {
        return realm.configuration.fileURL
    }
}
