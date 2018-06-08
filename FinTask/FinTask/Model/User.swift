//
//  User.swift
//  FinTask
//
//  Created by Tomasz Pieczykolan on 08/06/2018.
//  Copyright © 2018 Tomasz Pieczykolan. All rights reserved.
//

import struct Foundation.URL

struct User {
    let name: String
    let avatarURL: URL
    let source: String
}

protocol UserCreatable {
    func toUser() -> User?
}
