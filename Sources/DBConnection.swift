//

import Foundation
import PostgreSQL

protocol DBConnectionConfigurationProtocol {
    var host:String { get }
    var dbName: String { get }
    var user:String { get }
    var password: String? { get }
    var port: String { get }
}

public struct DBConnectionConfiguration: DBConnectionConfigurationProtocol {
    
    let host:String
    let dbName: String
    let user:String
    let password: String?
    let port: String
    
    public init(host: String = "localhost", dbName: String = "postgres", user:String, password: String? = nil, port: String = "5432") {
        self.host = host
        self.dbName = dbName
        self.user = user
        self.password = password
        self.port = port
    }
    
    public static var defaultConfiguration: DBConnectionConfiguration {
        return DBConnectionConfiguration(user: "greg")
    }
}


public class DBConnectionManager {
    
    public static let shared = DBConnectionManager()
    
    var currentConfiguration: DBConnectionConfigurationProtocol?
    
    lazy var postgres: PGConnection? = {
        guard let currentConfiguration = self.currentConfiguration else {
            assert(false, "Don't provided configuration")
            return nil
        }
        let connectionString:String = "host=\(currentConfiguration.host) " +
            "dbname=\(currentConfiguration.dbName) " +
            "user=\(currentConfiguration.user) " +
            (currentConfiguration.password != nil ? "password=\(currentConfiguration.password!) " : "")
            + "port=\(currentConfiguration.port)"
        let postgres = PGConnection()
        let status = postgres.connectdb(connectionString)
        switch status {
        case .bad:
            assert(false, "cannot connect to db, check connection")
            return nil
        case .ok:
            return postgres
        }
    }()
}
