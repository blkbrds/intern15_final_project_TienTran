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
                if realm.isInWriteTransaction {
                    realm.add(object)

                    completion(true, "")
                } else {
                    completion(false, "Object has been saved in Realm")
                }
            }
        } catch {
            completion(false, error.localizedDescription)
        }
    }


    /// Delete  object from the Realm
    func deleteObject<T: Object>(object: T, completion: @escaping Completion) {
        do {
            try realm.write {
                if realm.isInWriteTransaction {
                    realm.delete(object)
                    completion(true, "")
                } else {
                    completion(false, "Object has been saved in Realm")
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

    /// getNumberArticlesForCategory
    func getCountOfObjects() -> Int {
        return 10
    }

    /// The local URL of the Realm file
    func configurationFileURL() -> URL? {
        return realm.configuration.fileURL
    }

    // check realm have contains news?
    func isRealmContainsObject<Element: Object, KeyType>(object: Element, forPrimaryKey key: KeyType) -> Bool {
        guard realm.object(ofType: Element.self, forPrimaryKey: key) != nil else { return false }
        return true
    }
}

/*
 func getObjectForKey<T: Object, K>(object: T.Type, forPrimaryKey: K, completion: @escaping (T?, APIError?) -> Void) {
     guard let object = realm.object(ofType: T.self, forPrimaryKey: forPrimaryKey) else {
         completion(nil, APIError.error("Empty Object with for Primary Key."))
         return
     }
     completion(object, nil)
 }
 
 
 */
