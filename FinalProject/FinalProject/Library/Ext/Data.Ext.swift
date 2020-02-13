//
//  Data.Ext.swift
//  FinalProject
//
//  Created by PCI0002 on 2/13/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

extension Data {
    func toJSON() -> JSON {
        var json: JSON = [:]
        do {
            if let jsonObj = try JSONSerialization.jsonObject(with: self, options: .mutableLeaves) as? JSON {
                json = jsonObj
            }
        } catch {
            print("JSON casting error")
        }
        return json
    }
}
