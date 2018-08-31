//
//  PhotoManager.swift
//  ShowtimeHomeWork
//
//  Created by Vitalii Kotivskyi on 8/21/18.
//  Copyright © 2018 epam. All rights reserved.
//

import Foundation
import UIKit
import Result

class FlickrPhotoLoader {

    struct Constants {
        static let flickrAPIKey = "5423dbab63f23a62ca4a986e7cbb35e2"
        static let maxRetryFetchCount = 5
    }

    static let shared = FlickrPhotoLoader()

    let networkProvider: FlickrNetworkProviderProtocol
    let photosCache: FlickPhotosCache

    let workingQueue = DispatchQueue(label: "FlickrPhotoLoader")
    
    init() {
        networkProvider = FlickrNetworkProvider(flickrApiKey: Constants.flickrAPIKey)
        photosCache = FlickPhotosMemoryCache.init(networkProvider: networkProvider)
    }
}

extension FlickrPhotoLoader: PhotoLoaderProtocol {
    func fetchPhotoEntities(count: Int, completion: @escaping (Error?, [PhotoEntity]?) -> ()) {
        workingQueue.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            var prepearedEntities = [PhotoEntity]()
            let dispatchGroup = DispatchGroup()

            for _ in 1...count {
                dispatchGroup.enter()

                strongSelf.retryableFetchNextPhotoEntity(retryIteration: 0, maxRetryCount: Constants.maxRetryFetchCount, { result in
                    self?.workingQueue.async {
                        if let photoEntity = result.value {
                            prepearedEntities.append(photoEntity)
                        }
                        dispatchGroup.leave()
                    }
                })
            }

            dispatchGroup.notify(queue: strongSelf.workingQueue, execute: {
                if prepearedEntities.count == count {
                    completion(nil, prepearedEntities)
                } else {
                    completion(PhotoLoaderError.fetchingFailed, nil)
                }
            })
        }
    }
}

extension FlickrPhotoLoader {
    func retryableFetchNextPhotoEntity(retryIteration: Int, maxRetryCount: Int, _ completion: @escaping (Result<PhotoEntity, PhotoLoaderError>) -> ()) {
        if retryIteration >= maxRetryCount {
            completion(Result.failure(PhotoLoaderError.fetchingFailed))
            return
        }

        fetchNextPhotoEntity {[weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success:
                completion(result)
            case .failure:
                strongSelf.retryableFetchNextPhotoEntity(retryIteration: retryIteration+1, maxRetryCount: maxRetryCount, completion)
            }
        }
    }

    func fetchNextPhotoEntity(_ completion: @escaping (Result<PhotoEntity, PhotoLoaderError>) -> ()) {
        photosCache.getNext { [weak self] result in
            guard let strongSelf = self else {
                return
            }

            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(let photoInfo):
                strongSelf.networkProvider.getPhoto(photoInfo: photoInfo , { imageResult in
                    completion(imageResult.map({ image -> PhotoEntity in
                        return PhotoEntity(photoId: photoInfo.photoId, image: image)
                    }))
                })
            }
        }
    }
}
