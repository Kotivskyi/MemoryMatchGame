//
//  FlickNetworkProviderProtocol.swift
//  ShowtimeHomeWork
//
//  Created by Vitalii Kotivskyi on 8/22/18.
//  Copyright © 2018 epam. All rights reserved.
//

import Foundation
import Result

protocol FlickrNetworkProviderProtocol {
    func searchPhotos(page: Int, _ completion: @escaping (Result<FlickrSearchPhotosResult, PhotoLoaderError>)->())
    func getPhoto(photoInfo: FlickrPhotoInfo, _ completion: @escaping (Result<UIImage, PhotoLoaderError>)->())
}

class FlickrNetworkProvider {
    
    let flickrApiKey: String

    init(flickrApiKey: String) {
        self.flickrApiKey = flickrApiKey
    }
}

extension FlickrNetworkProvider: FlickrNetworkProviderProtocol {
    func searchPhotos(page: Int, _ completion: @escaping (Result<FlickrSearchPhotosResult, PhotoLoaderError>)->()) {
        guard let requestURL = FlickrNetworkProvider.buildPhotosSearchURL(page: page, apiKey: flickrApiKey) else {
            completion(Result.failure(PhotoLoaderError.invalidRequest))
            return
        }

        let dataTask = URLSession.shared.dataTask(with: requestURL) { data, response, requestError in
            if let requestError = requestError {
                completion(Result.failure(PhotoLoaderError.general(requestError)))
                return
            }

            guard let data = data else {
                completion(Result.failure(PhotoLoaderError.invalidResponse))
                return
            }

            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary else {
                    throw PhotoLoaderError.invalidResponse
                }

                let searchResult: FlickrSearchPhotosResult = try FlickrNetworkProvider.parse(with: json)
                completion(Result.success(searchResult))
            }
            catch let error as PhotoLoaderError {
                completion(Result.failure(error))
                return
            }
            catch {
                completion(Result.failure(PhotoLoaderError.general(error)))
                return
            }
        }

        dataTask.resume()
    }

    func getPhoto(photoInfo: FlickrPhotoInfo, _ completion: @escaping (Result<UIImage, PhotoLoaderError>)->()) {
        guard let photoURL = FlickrNetworkProvider.buildPhotoURL(with: photoInfo) else {
            completion(Result.failure(PhotoLoaderError.invalidRequest))
            return
        }

        do {
            let photoData = try Data(contentsOf: photoURL)
            if let image = UIImage(data: photoData) {
                completion(Result.success(image))
            } else {
                completion(Result.failure(PhotoLoaderError.invalidResponse))
            }
        } catch {
            completion(Result.failure(PhotoLoaderError.general(error)))
        }

    }
}
