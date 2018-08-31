//
//  gameEngineProtocol.swift
//  ShowtimeHomeWork
//
//  Created by Vitalii Kotivskyi on 8/21/18.
//  Copyright © 2018 epam. All rights reserved.
//

import Foundation

struct CardGameOptions {
    let size: UInt
}

protocol GameEngineProtocol {

    var gameField: GameField? { get }

    var isGameFinished: Bool { get }

    func filpItem(at indexPath: IndexPath)

    func setupGame(options: CardGameOptions, _ completion: @escaping (Bool) -> ())
}
