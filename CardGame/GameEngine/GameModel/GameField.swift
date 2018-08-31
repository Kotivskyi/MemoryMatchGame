//
//  GameField.swift
//  ShowtimeHomeWork
//
//  Created by Vitalii Kotivskyi on 8/21/18.
//  Copyright © 2018 epam. All rights reserved.
//

import Foundation

struct GameField {
    let width: Int
    let height: Int
    
    let items: [GameFieldItem]

    init(width: Int, height: Int, photos: [PhotoEntity]) {
        assert(photos.count == width * height)
        self.width = width
        self.height = height
        items = photos.map { photoEntity -> GameFieldItem in
            return GameFieldItem(photoEntity)
        }
    }
}

extension GameField {
    func item(at indexPath: IndexPath) throws -> GameFieldItem {
        if (indexPath.row < 0 || indexPath.row >= width) ||
            (indexPath.section < 0 || indexPath.section >= height) {
            throw GameEngineError.indexOutOfBounds(indexPath)
        }
        return items[indexPath.section * width + indexPath.row]
    }
}
