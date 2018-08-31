//
//  GameFieldItem.swift
//  ShowtimeHomeWork
//
//  Created by Vitalii Kotivskyi on 8/21/18.
//  Copyright © 2018 epam. All rights reserved.
//

import Foundation

enum GameFieldItemState {
    case closed
    case open
    case finished
}

class GameFieldItem {
    var state: GameFieldItemState = .closed
    let photoEntity: PhotoEntity

    init(_ photoEntity: PhotoEntity) {
        self.photoEntity = photoEntity
    }

    var isClosed: Bool {
        return state == .closed
    }
}
