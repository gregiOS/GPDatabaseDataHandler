//

import Foundation
import PostgreSQL

public protocol DBConnectionConfigurationProtocol {
    var host:String { get }
    var dbName: String { get }
    var user:String { get }
    var password: String? { get }
    var port: String { get }
}

public struct DBConnectionConfiguration: DBConnectionConfigurationProtocol {
    
    public let host:String
    public let dbName: String
    public let user:String
    public let password: String?
    public let port: String
    
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
    
    public var currentConfiguration: DBConnectionConfigurationProtocol?
    
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
