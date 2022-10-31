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

    private var _fetchResult: PHFetchResult<PHAsset>?
}

extension PhotosService: PhotosInteractor {

    var authorizationStatus: PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus()
    }

    var assetsFetchResult: PHFetchResult<PHAsset> {
        if let _fetchResult = _fetchResult {
            return _fetchResult
        } else {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let result = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            _fetchResult = result
            return result
        }
    }

    func requestAccess(completion: @escaping (PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization() { (status) in
            DispatchQueue.main.async {
                completion(status)
            }
        }
    }
}
