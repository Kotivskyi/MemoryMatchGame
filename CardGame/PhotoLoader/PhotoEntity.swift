//
//  PhotoEntity.swift
//  ShowtimeHomeWork
//
//  Created by Vitalii Kotivskyi on 8/22/18.
//  Copyright © 2018 epam. All rights reserved.
//

import Foundation
import UIKit

class PhotoEntity {
    let photoId : String
    let image: UIImage

    convenience init() {
        self.init(photoId: UUID().uuidString, image: #imageLiteral(resourceName: "testImage"))
    }

    init(photoId: String,
         image: UIImage) {
        self.photoId = photoId
        self.image = image
    }
}

extension PhotoEntity: Equatable {
    static func == (lhs: PhotoEntity, rhs: PhotoEntity) -> Bool {
        return lhs.photoId == rhs.photoId
    }
}
