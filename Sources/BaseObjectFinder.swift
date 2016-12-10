//
//  BasePersonalFinder.swift
//  PerfectTemplate
//
//  Created by Greg on 17/11/2016.
//
//

import Foundation
import PostgreSQL

protocol BaseObjectFinder {
    // MARK: Properties
    var dbTableName: String { get }
    
    var dataBaseOperationsProxy:DataBaseOperationsProxy? { get set }
    
    //MARK: Public functions
    func execute(sqlString: String) -> [String: Any]?
    func executeMany(sqlString: String) -> [[String: Any]]?

}

extension BaseObjectFinder {
    
    func execute(sqlString: String) -> [String: Any]? {
        return dataBaseOperationsProxy?.executeAndParse(sqlString: sqlString)
    }
    
    func executeMany(sqlString: String) -> [[String: Any]]? {
        return dataBaseOperationsProxy?.executeAndParseMany(sqlString: sqlString)
    }
    
   
}
