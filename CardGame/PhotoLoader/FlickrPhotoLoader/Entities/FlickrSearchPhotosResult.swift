//
//  FlickrSearchPhotosResult.swift
//  ShowtimeHomeWork
//
//  Created by Vitalii Kotivskyi on 8/22/18.
//  Copyright © 2018 epam. All rights reserved.
//

import Foundation

struct FlickrSearchPhotosResult {
    let page: Int
    let totalPages: Int
    let photos: [FlickrPhotoInfo]
}
