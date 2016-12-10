//
//  Student.swift
//  PerfectTemplate
//
//  Created by Greg on 13/11/2016.
//
//

import Foundation
import PostgreSQL

struct GAPObjectMapper: BaseDataMapper {
    
    let dbTableName: String
    
    internal var dataBaseOperationsProxy: DataBaseOperationsProxy?
    
    init(dbTableName: String) {
        self.dbTableName = dbTableName
        dataBaseOperationsProxy = PSQLDataBaseOperationsProxy()
    }
    
    func insert(objectDictionary: [String: Any]) -> Bool {
        var objectDictionary = objectDictionary
        objectDictionary.removeValue(forKey: "id")
        let sqlString = buildCommand(objectDictionary: objectDictionary, command: "INSERT INTO \(dbTableName)")
        return dataBaseOperationsProxy?.execute(sqlString: sqlString) ?? false
    }
    
    func update(objectDictionary: [String: Any]) -> Bool {
        var objectDictionary = objectDictionary
        guard let objectID = objectDictionary["id"] else { return false }
        objectDictionary.removeValue(forKey: "id")
        let sqlString = buildUpdateCommand(objectDictionary: objectDictionary, command: "UPDATE \(dbTableName) SET ", whereClausule: "id = \(objectID)")
        return dataBaseOperationsProxy?.execute(sqlString: sqlString) ?? false
    }
    
    func delete(objectDictionary: [String: Any]) -> Bool {
        return true
    }
    
    private func buildCommand(objectDictionary: [String: Any], command: String, whereClausule: String? = nil) -> String {
        let columnNames = objectDictionary.keys.joined(separator: ",")
        let objects = objectDictionary.values.map({"'\($0)'"}).joined(separator: ",")
        //INSERT INTO films (code, title, did, date_prod, kind)
        let sqlString = command + " (" + columnNames + ") VALUES " + "(" + objects + ")"
            + (whereClausule != nil ? "WHERE " + whereClausule! : "")
        print(sqlString)
        return sqlString
    }
    
    private func buildUpdateCommand(objectDictionary: [String: Any], command: String, whereClausule: String) -> String {
        let columnNames = objectDictionary.keys.joined(separator: ",")
        let objects = objectDictionary.values.map({"'\($0)'"}).joined(separator: ",")
        let sqlString = command + "(" + columnNames + ")" + " = " + "(" + objects + ")"
        + "WHERE " + whereClausule
        return sqlString
    }

}
