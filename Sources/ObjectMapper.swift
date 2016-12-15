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
        
        let sqlString = PSQLQueryFactory.insert(objectDictionary, dbTableName).buildQuery()
        return dataBaseOperationsProxy?.execute(sqlString: sqlString) ?? false
    }
    
    func update(objectDictionary: [String: Any]) -> Bool {
        
        let sqlString = PSQLQueryFactory.update(objectDictionary, dbTableName, "id").buildQuery()
        return dataBaseOperationsProxy?.execute(sqlString: sqlString) ?? false
    }
    
    func delete(objectDictionary: [String: Any]) -> Bool {
        let sqlString = PSQLQueryFactory.delete(objectDictionary, dbTableName, "id").buildQuery()
        return dataBaseOperationsProxy?.execute(sqlString: sqlString) ?? false
    }
    
}
