//
//  User+Store.swift
//  FinTask
//
//  Created by Tomasz Pieczykolan on 08/06/2018.
//  Copyright © 2018 Tomasz Pieczykolan. All rights reserved.
//

extension User {
    
    /// Fetches users from API.
    ///
    /// For each API that the users are fetched from one block will be called.
    ///
    /// Each successful fetch will call `newUsersHandler` once with only the users from specific API.
    /// Use it to append to your models, not replace them.
    ///
    /// Each failed request will call `errorHandler` once with `Error` describing the problem.
    static func fetchAll(newUsersHandler: @escaping ([User]) -> Void, errorHandler: @escaping (Swift.Error) -> Void) {
        API.shared.getDailymotionUsers(successHandler: { dailymotionUsers in
            let newUsers = dailymotionUsers.compactMap { $0.toUser() }
            newUsersHandler(newUsers)
        }, errorHandler: errorHandler)
        
        API.shared.getGitHubUsers(successHandler: { gitHubUsers in
            let newUsers = gitHubUsers.compactMap { $0.toUser() }
            newUsersHandler(newUsers)
        }, errorHandler: errorHandler)
    }
}
