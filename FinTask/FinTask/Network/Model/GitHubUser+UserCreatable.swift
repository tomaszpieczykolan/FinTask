//
//  GitHubUser+UserCreatable.swift
//  FinTask
//
//  Created by Tomasz Pieczykolan on 08/06/2018.
//  Copyright © 2018 Tomasz Pieczykolan. All rights reserved.
//

import struct Foundation.URL

extension GitHubUser: UserCreatable {
    func toUser() -> User? {
        guard let url = URL(string: avatar_url) else { return nil }
        return User(
            name: login,
            avatarURL: url,
            source: "GitHub"
        )
    }
}
