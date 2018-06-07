//
//  DailymotionResponse.swift
//  FinTask
//
//  Created by Tomasz Pieczykolan on 07/06/2018.
//  Copyright © 2018 Tomasz Pieczykolan. All rights reserved.
//

struct DailymotionResponse: Decodable {
    let list: [DailymotionUser]
}
