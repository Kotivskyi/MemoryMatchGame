//
//  PhotoManagerProtocol.swift
//  ShowtimeHomeWork
//
//  Created by Vitalii Kotivskyi on 8/21/18.
//  Copyright © 2018 epam. All rights reserved.
//

import Foundation

protocol PhotoLoaderProtocol {
    func fetchPhotoEntities(count: Int, completion: @escaping (Error?, [PhotoEntity]?) -> ())
}
