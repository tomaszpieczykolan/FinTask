//
//  User.swift
//  FinTask
//
//  Created by Tomasz Pieczykolan on 08/06/2018.
//  Copyright © 2018 Tomasz Pieczykolan. All rights reserved.
//

import struct Foundation.URL

struct User {
    
    /// Name (aka username or nickname) of the user
    let name: String
    
    /// URL to avatar resource. Download it on your own.
    let avatarURL: URL
    
    /// Name of the API that the user was fetched from.
    let source: String
}

protocol UserCreatable {
    func toUser() -> User?
}
