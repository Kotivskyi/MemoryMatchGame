//
//  PhotoLoaderError.swift
//  ShowtimeHomeWork
//
//  Created by Vitalii Kotivskyi on 8/22/18.
//  Copyright © 2018 epam. All rights reserved.
//

import Foundation

enum PhotoLoaderError: Error {
    case invalidRequest
    case invalidResponse
    case general(Error)
    case fetchingFailed
}
