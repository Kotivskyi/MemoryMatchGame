//
//  PhotoInfosCache.swift
//  ShowtimeHomeWork
//
//  Created by Vitalii Kotivskyi on 8/22/18.
//  Copyright © 2018 epam. All rights reserved.
//

import Foundation
import Result

protocol FlickPhotosCache {

    func getNext(_ completion: @escaping (Result<FlickrPhotoInfo, PhotoLoaderError>) -> ()) 
}
