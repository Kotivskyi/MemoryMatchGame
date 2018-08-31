//
//  FlickrNetworkProvider+RequestBuilders.swift
//  ShowtimeHomeWork
//
//  Created by Vitalii Kotivskyi on 8/22/18.
//  Copyright © 2018 epam. All rights reserved.
//

import Foundation

extension FlickrNetworkProvider {

    static func buildPhotosSearchURL(page: Int, apiKey: String) -> URL? {
        return URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=dog&page=\(page)&format=json&nojsoncallback=1")
    }

    static func buildPhotoURL(with photoInfo: FlickrPhotoInfo) -> URL? {
        return URL(string: "https://farm\(photoInfo.farm).staticflickr.com/\(photoInfo.server)/\(photoInfo.photoId)_\(photoInfo.secret)_q.jpg")
    }
}
