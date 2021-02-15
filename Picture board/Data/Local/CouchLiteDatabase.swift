//
//  CouchLiteDatabase.swift
//  Picture board
//
//  Created by Eleazar Estrella on 2/15/21.
//

import Foundation
import CouchbaseLiteSwift

struct CouchLiteDataBase {
    
    var database: Database
    
    public static let DataBaseName = "posts-db"
    
    private init (database: Database) {
        self.database = database
    }
    
    static let shared: CouchLiteDataBase = {
        let database: Database
        let databaseName = DataBaseName
        if let path = Bundle.main.path(forResource: databaseName, ofType: "cblite2"),
           !Database.exists(withName: databaseName) {
          do {
            try Database.copy(fromPath: path, toDatabase: databaseName, withConfig: nil)
          } catch {
            fatalError("Could not load pre-built database")
          }
        }

        do {
          database = try Database(name: databaseName)
        } catch {
          fatalError("Error opening database")
        }
        
        let instance = CouchLiteDataBase(database: database)
        
        return instance
    }()
}
