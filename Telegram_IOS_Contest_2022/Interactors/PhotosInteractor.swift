//
//  PhotosInteractor.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 09.10.2022.
//

import Foundation
import PhotosUI

protocol PhotosInteractor: AnyObject {
    var authorizationStatus: PHAuthorizationStatus { get }
    var assetsFetchResult: PHFetchResult<PHAsset> { get }

    func requestAccess(completion: @escaping (PHAuthorizationStatus) -> Void)
}

final class PhotosService {

    static let shared: PhotosInteractor = PhotosService()
}

extension PhotosService: PhotosInteractor {

    var authorizationStatus: PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }

    var assetsFetchResult: PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        return PHAsset.fetchAssets(with: .image, options: fetchOptions)
    }

    func requestAccess(completion: @escaping (PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
            DispatchQueue.main.async {
                completion(status)
            }
        }
    }
}
