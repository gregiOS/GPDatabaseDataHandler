//
//  QueryFactory.swift
//  GPDatabaseDataHandler
//
//  Created by Greg on 15/12/2016.
//
//

import Foundation

protocol QueryObject {
    func buildQuery() -> String
}


enum PSQLQueryFactory: QueryObject {
    case update([String: Any], String, String) // first dictionary represents dictionary, //second string dbTableName, // third primaryKey
    case insert([String: Any], String)
    case delete([String: Any], String, String) // ObjectDict, PrimaryKey, TableName
    
    func buildQuery() -> String {
        switch self {
        case .update(let dictionary, let dbTableName, let primaryKey):
            return buildUpdateQuery(objectDictionary: dictionary, command: "UPDATE \(dbTableName) SET", primaryKey: primaryKey)
        case .insert(let dictionary, let dbTableName):
            return buildInsertQuery(objectDictionary: dictionary, command: "INSERT INTO \(dbTableName)")
        case .delete(let dictionary, let primaryKey, let dbTableName):
            return buildDeleteQuery(objectDictionary: dictionary, command: "DELETE FROM \(dbTableName)", primaryKey: primaryKey)
        }
    }
    
    private func buildUpdateQuery(objectDictionary: [String: Any], command: String, primaryKey: String? = nil) -> String {
        var objectDictionary = objectDictionary
        guard let primaryKey = primaryKey, let objectID = objectDictionary[primaryKey] else { return "" }
        
        objectDictionary.removeValue(forKey: primaryKey)
        
        let columnNames = objectDictionary.keys.joined(separator: ",")
        let objects = objectDictionary.values.map({"'\($0)'"}).joined(separator: ",")
        
        let sqlString = command + " (" + columnNames + ") VALUES " + "(" + objects + ")"
            + "WHERE " + "\(primaryKey) = \(objectID)"
        
        return sqlString
    }
    
    private func buildInsertQuery(objectDictionary: [String: Any], command: String) -> String {
        let columnNames = objectDictionary.keys.joined(separator: ",")
        let objects = objectDictionary.values.map({"'\($0)'"}).joined(separator: ",")
        
        let sqlString = command + " (" + columnNames + ") VALUES " + "(" + objects + ")"
        return sqlString
    }
    
    private func buildDeleteQuery(objectDictionary: [String: Any], command: String, primaryKey: String? = nil) -> String {
        guard let primaryKey = primaryKey, let objectID = objectDictionary[primaryKey] else { return "" }
        let sqlString = command + " WHERE " + "\(primaryKey) = \(objectID)"
        return sqlString
    }
}
