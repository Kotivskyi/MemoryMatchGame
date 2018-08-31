//
//  Collection+Shuffle.swift
//  ShowtimeHomeWork
//
//  Created by Vitalii Kotivskyi on 8/21/18.
//  Copyright © 2018 epam. All rights reserved.
//

import Foundation

extension MutableCollection {
    mutating func shuffle() {
        guard count > 1 else { return }
        
        for (currentPosition, unshuffledCount) in zip(indices, stride(from: count, to: 1, by: -1)) {
            let randomOffset = Int(arc4random_uniform(UInt32(unshuffledCount)))
            let newPosition = index(currentPosition, offsetBy: randomOffset)
            swapAt(currentPosition, newPosition)
        }
    }
}

