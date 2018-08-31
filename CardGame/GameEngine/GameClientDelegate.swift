//
//  GameEngineDelegate.swift
//  ShowtimeHomeWork
//
//  Created by Vitalii Kotivskyi on 8/21/18.
//  Copyright © 2018 epam. All rights reserved.
//

import Foundation

protocol GameEngineDelegate: class {
    func onUpdate(item: GameFieldItem, indexPath: IndexPath)
    func onGameFinished()
}
