//
//  FlickPhotosMemoryCache.swift
//  ShowtimeHomeWork
//
//  Created by Vitalii Kotivskyi on 8/22/18.
//  Copyright © 2018 epam. All rights reserved.
//

import Foundation
import Result

class FlickPhotosMemoryCache: FlickPhotosCache {

    let semaphore = DispatchSemaphore(value: 1)

    var items = [FlickrPhotoInfo]()

    var lastPage: Int = 0

    let networkProvider: FlickrNetworkProviderProtocol

    init(networkProvider: FlickrNetworkProviderProtocol) {
        self.networkProvider = networkProvider
    }

    func getNext(_ completion: @escaping (Result<FlickrPhotoInfo, PhotoLoaderError>) -> ()) {
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        if let item = items.popLast() {
            semaphore.signal()
            print("getNext \(item.photoId)")
            completion(Result.success(item))
        } else {
            refill {[weak self] error in
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    strongSelf.semaphore.signal()
                    completion(Result.failure(error))
                }
                if let item = strongSelf.items.popLast() {
                    strongSelf.semaphore.signal()
                    completion(Result.success(item))
                } else {
                    assertionFailure()
                }
            }
        }
    }

    func refill(_ completion: @escaping (PhotoLoaderError?)->()) {
        print("refill")
        let nextPage = lastPage + 1
        lastPage = lastPage + 1
        networkProvider.searchPhotos(page: nextPage + 1) {[weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .failure(let error):
                completion(error)
            case .success(let searchResult):
                strongSelf.items.append(contentsOf: searchResult.photos)
                completion(nil)

            }
        }
    }
}
