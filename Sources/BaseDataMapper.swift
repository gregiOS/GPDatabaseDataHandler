//
//  BaseDataMapper.swift
//  PerfectTemplate
//
//  Created by Greg on 17/11/2016.
//
//

import Foundation

protocol BaseDataMapper {
    func insert(objectDictionary: [String: Any]) -> Bool
    func update(objectDictionary: [String: Any]) -> Bool
    func delete(objectDictionary: [String: Any]) -> Bool
}

