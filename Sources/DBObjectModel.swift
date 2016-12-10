//
//  DBObjectModel.swift
//  PerfectTemplate
//
//  Created by Greg on 20/11/2016.
//
//

import Foundation
import PostgreSQL
import ObjectMapper

protocol DBObjectModel: Mappable {
    
    static var dbTableName: String { get }
    
    static func getObject(with id: Int) -> Self?
    static func all() -> [Self?]?
    static func emptyInit() -> Self?
    
    @discardableResult
    func insert() -> Bool
    @discardableResult
    func update() -> Bool
    
}

extension DBObjectModel {
    
    
    static func emptyInit() -> Self? {
        let jsonEmpty: [String: Any] = [:]
        return Mapper().map(JSON: jsonEmpty)
    }
    
    static func getObject(with id: Int) -> Self? {
        let objectFinder = ObjectFinder(dbTableName: dbTableName)
        guard let json = objectFinder.find(with: id) else { return nil }
        return Mapper().map(JSON: json)
    }
    
    @discardableResult
    func insert() -> Bool {
        let objectMapper = GAPObjectMapper(dbTableName: Self.dbTableName)
        let objectDict = self.toJSON()
        return objectMapper.insert(objectDictionary: objectDict)
    }
    
    @discardableResult
    func update() -> Bool {
        let objectMapper = GAPObjectMapper(dbTableName: Self.dbTableName)
        let objectDict = self.toJSON()
        return objectMapper.update(objectDictionary: objectDict)
    }
    
    static func all() -> [Self?]? {
        let objectFinder = ObjectFinder(dbTableName: dbTableName)
        guard let objectsArray = objectFinder.findAll() else { return nil }
        return objectsArray.map{ Mapper().map(JSON: $0) }
        
    }
    
}
