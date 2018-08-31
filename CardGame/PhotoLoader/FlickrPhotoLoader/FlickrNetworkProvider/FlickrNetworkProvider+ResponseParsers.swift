//
//  FlickrNetworkProvider+Decoders.swift
//  ShowtimeHomeWork
//
//  Created by Vitalii Kotivskyi on 8/22/18.
//  Copyright © 2018 epam. All rights reserved.
//

import Foundation

extension FlickrNetworkProvider {

    static func parse(with json: NSDictionary) throws -> FlickrPhotoInfo {
        guard let photoId = json["id"] as? String,
            let secret = json["secret"] as? String,
            let server = json["server"] as? String,
            let farm = json["farm"] as? Int else {
                throw PhotoLoaderError.invalidResponse
        }
        return FlickrPhotoInfo(photoId: photoId, secret: secret, server: server, farm: farm)
    }

    static func parse(with json: NSDictionary) throws -> FlickrSearchPhotosResult {
        guard let photosObject = json["photos"] as? NSDictionary else {
            throw PhotoLoaderError.invalidResponse
        }
        guard let page = photosObject["page"] as? Int,
            let totalPages = photosObject["pages"] as? Int,
            let photosList = photosObject["photo"] as? NSArray else {
                throw PhotoLoaderError.invalidResponse
        }

        let photos = try photosList.map { item -> FlickrPhotoInfo in
            guard let item = item as? NSDictionary else {
                throw PhotoLoaderError.invalidResponse
            }
            return try FlickrNetworkProvider.parse(with: item)
        }

        return FlickrSearchPhotosResult(page: page, totalPages: totalPages, photos: photos)
    }

}

