//
//  DataBaseOperationsProxy.swift
//  PerfectTemplate
//
//  Created by Greg on 20/11/2016.
//
//

import Foundation
import PostgreSQL

protocol DataBaseOperationsProxy {
    
    func executeAndParse(sqlString: String) -> [String: Any]?
    func executeAndParseMany(sqlString: String) -> [[String: Any]]?
    func execute(sqlString: String) -> Bool
}

struct PSQLDataBaseOperationsProxy: DataBaseOperationsProxy {
    
    var postgresConnection:PGConnection?
    
    init(postgresConnection: PGConnection? = DBConnectionManager.shared.postgres) {
        self.postgresConnection = postgresConnection
    }
    
    internal func execute(sqlString: String) -> Bool {
        guard let connection = postgresConnection else {
            assert(false, "No db Connection Provided")
            return false
        }
        let result = connection.exec(statement: sqlString)
        switch result.status() {
        case .commandOK:
            print("execute command: \(sqlString) with success")
            return true
        case .badResponse, .emptyQuery, .fatalError, .nonFatalError, .unknown:
            assert(false, "executing sql command: \(sqlString), finished with error: \(result.status())")
            return false
        default:
            return false
        }
    }
    
    internal func executeAndParse(sqlString: String) -> [String: Any]? {
        guard let connection = postgresConnection else { return nil }
        return parse(results: connection.exec(statement: sqlString))
    }
    
    internal func executeAndParseMany(sqlString: String) -> [[String : Any]]? {
        guard let connection = postgresConnection else { return nil }
        return parseMany(results: connection.exec(statement: sqlString))
    }
    
    func parse(results: PGResult) -> [String: Any]? {
        let rowNum = results.numTuples()
        guard rowNum != 0 else { return nil }
        let columnsNum = results.numFields()
        var resultsDict:[String: Any] = [String: AnyObject]()
        for x in 0..<columnsNum {
            guard let columnName = results.fieldName(index: x),
                let columnType = results.fieldType(index: x) else { continue }
            switch columnType {
            case 23:
                if let intValue = results.getFieldInt(tupleIndex: 0, fieldIndex: x) {
                    resultsDict[columnName] = intValue as AnyObject
                }
            case 16:
                resultsDict[columnName] = results.getFieldBool(tupleIndex: 0, fieldIndex: x) as AnyObject?
            case 20:
                resultsDict[columnName] = results.getFieldInt8(tupleIndex: 0, fieldIndex: x) as AnyObject?
            case 1043:
                resultsDict[columnName] = results.getFieldString(tupleIndex: 0, fieldIndex: x) as AnyObject?
            default:
                assert(false, "There is one columen that I don't recognize well \(columnName), columnType: \(columnType)")
            }
        }
        return resultsDict
    }
    
    func parseMany(results: PGResult) -> [[String: Any]]? {
        let rowNum = results.numTuples()
        guard rowNum != 0 else { return nil }
        let columnsNum = results.numFields()
        var resultArray: [[String: Any]] = [[:]]
        for rowIndex in 0..<rowNum {
            var resultsDict:[String: Any] = [:]
            for x in 0..<columnsNum {
                guard let columnName = results.fieldName(index: x),
                    let columnType = results.fieldType(index: x) else { continue }
                switch columnType {
                case 23:
                    if let intValue = results.getFieldInt(tupleIndex: rowIndex, fieldIndex: x) {
                        resultsDict[columnName] = intValue as AnyObject
                    }
                case 16:
                    resultsDict[columnName] = results.getFieldBool(tupleIndex: rowIndex, fieldIndex: x) as AnyObject?
                case 20:
                    resultsDict[columnName] = results.getFieldInt8(tupleIndex: rowIndex, fieldIndex: x) as AnyObject?
                case 1043:
                    resultsDict[columnName] = results.getFieldString(tupleIndex: rowIndex, fieldIndex: x) as AnyObject?
                default:
                    assert(false, "There is one columen that I don't recognize well \(columnName), columnType: \(columnType)")
                }
            }
            resultArray.append(resultsDict)
        }
        return resultArray
    }
}
