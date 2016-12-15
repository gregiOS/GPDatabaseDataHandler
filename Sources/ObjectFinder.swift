//
//  StudentFinder.swift
//  PerfectTemplate
//
//  Created by Greg on 13/11/2016.
//
//

import Foundation
import PostgreSQL
import libpq

/*
 // Developer create an ModelObject which confirm to my protocol DBObjectMaintable
 extenstion to this protocol take care about whole fetch data job
 // Need to provide this extenstion in way that -> user can override some methods, what allows to
 extend current implementation -> Maybe it need's to make some joins
 so I nned to provide the method that allows you to insert default sql
 
 
 */
struct ObjectFinder: BaseObjectFinder {

    let dbTableName: String

    internal var dataBaseOperationsProxy: DataBaseOperationsProxy?
    
    init(dbTableName: String) {
        self.dbTableName = dbTableName
        self.dataBaseOperationsProxy = PSQLDataBaseOperationsProxy()
    }
    
    /*
     @brief base method that will be call when someone use getter ObjectModel.get(withId: 10)
     */
    internal func find(with id: Int) -> [String: Any]? {
        return execute(sqlString: PSQLQueryFactory.select(dbTableName, "id = \(id)").buildQuery())
    }
    
    internal func findAll() -> [[String: Any]]? {
        return executeMany(sqlString: PSQLQueryFactory.selectAll(dbTableName).buildQuery())
    }
    
    }
