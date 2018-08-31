//
//  CardgameEngine.swift
//  ShowtimeHomeWork
//
//  Created by Vitalii Kotivskyi on 8/21/18.
//  Copyright © 2018 epam. All rights reserved.
//

import Foundation

class FlipCardGameEngine {

    var gameField: GameField?

    var isGameFinished: Bool = false

    var lastSelectedItemIndexPath: IndexPath?

    let photoLoader: PhotoLoaderProtocol

    weak var delegate: GameEngineDelegate?

    init(photoLoader: PhotoLoaderProtocol) {
        self.photoLoader = photoLoader
    }

    func checkWinState() {
        guard let gameField = gameField else {
            return
        }
        let firstUnfinished = gameField.items.first { item -> Bool in
            return item.state != .finished
        }

        let isGameFinished = !(firstUnfinished != nil)
        if isGameFinished {
            self.isGameFinished = true
            delegate?.onGameFinished()
        }
    }
}

extension FlipCardGameEngine: GameEngineProtocol {

    func setupGame(options: CardGameOptions, _ completion: @escaping (Bool) -> ()) {
        assert(options.size % 2 == 0)
        let photosCount = Int(options.size * options.size / 2)
        photoLoader.fetchPhotoEntities(count: photosCount) { [weak self] error, fetchedPhotos in
            guard let strongSelf = self else {
                return
            }
            guard let fetchedPhotos = fetchedPhotos else {
                completion(false)
                return
            }

            var gameFieldPhotos = [PhotoEntity]()
            gameFieldPhotos.append(contentsOf: fetchedPhotos)
            gameFieldPhotos.append(contentsOf: fetchedPhotos)
            gameFieldPhotos.shuffle()

            strongSelf.gameField = GameField(width: Int(options.size),
                                  height: Int(options.size),
                                  photos: gameFieldPhotos)
            strongSelf.lastSelectedItemIndexPath = nil
            strongSelf.isGameFinished = false
            completion(true)
        }
    }

    func filpItem(at indexPath: IndexPath) {
        guard let gameField = gameField,
            let item = try? gameField.item(at: indexPath) else {
            return
        }

        if item.state == .finished {
            return
        }

        guard let lastSelectedItemIndexPath = lastSelectedItemIndexPath,
            let lastSelectedItem = try? gameField.item(at: lastSelectedItemIndexPath) else { // new item
            item.state = .open
            self.lastSelectedItemIndexPath = indexPath
            delegate?.onUpdate(item: item, indexPath: indexPath)
            return
        }

        if lastSelectedItemIndexPath == indexPath { // same item
            if item.state == .open {
                item.state = .closed
            } else {
                item.state = .open
            }
            delegate?.onUpdate(item: item, indexPath: indexPath)

        } else if item.photoEntity == lastSelectedItem.photoEntity { // found photo
            item.state = .finished
            lastSelectedItem.state = .finished
            self.lastSelectedItemIndexPath = nil
            delegate?.onUpdate(item: item, indexPath: indexPath)
            checkWinState()
        } else { // found other photo
            item.state = .open
            lastSelectedItem.state = .closed
            self.lastSelectedItemIndexPath = indexPath
            delegate?.onUpdate(item: item, indexPath: indexPath)
            delegate?.onUpdate(item: lastSelectedItem, indexPath: lastSelectedItemIndexPath)
        }

    }
}
