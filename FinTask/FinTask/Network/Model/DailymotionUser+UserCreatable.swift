//
//  DailymotionUser+UserCreatable.swift
//  FinTask
//
//  Created by Tomasz Pieczykolan on 08/06/2018.
//  Copyright © 2018 Tomasz Pieczykolan. All rights reserved.
//

import struct Foundation.URL

extension DailymotionUser: UserCreatable {
    func toUser() -> User? {
        guard let url = URL(string: avatar_360_url) else { return nil }
        return User(
            name: username,
            avatarURL: url,
            source: "Dailymotion"
        )
    }
}
