//
//  SelectPhotoViewController.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 09.10.2022.
//

import UIKit
import PhotosUI

final class SelectPhotoViewController: ViewController {

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

    override func setup() {
        view.backgroundColor = .black

        view.addSubview(collectionView)
        collectionView.register(SelectPhotoCell.self, forCellWithReuseIdentifier: "photoCell")
        collectionView.backgroundColor = .clear

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setupSizes() {
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1

        let side = collectionView.frame.width * 0.33
        layout.itemSize = .init(width: side, height: side)

        collectionView.setCollectionViewLayout(layout, animated: true)
    }

    var allPhotos: PHFetchResult<PHAsset> {
        PhotosService.shared.assetsFetchResult
    }
}

extension SelectPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! SelectPhotoCell

        let asset = allPhotos.object(at: indexPath.row)
        cell.imageView.fetchImage(asset: asset, contentMode: .aspectFill, targetSize: cell.imageView.frame.size)

        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let editorVC = EditorViewController(asset: allPhotos[indexPath.row])
        editorVC.modalPresentationStyle = .overFullScreen
        present(editorVC, animated: true)
    }
}

extension UIImageView {

    func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize) {
        let options = PHImageRequestOptions()
        options.version = .original
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options) { image, _ in
            guard let image = image else { return }
            switch contentMode {
            case .aspectFill:
                self.contentMode = .scaleAspectFill
            case .aspectFit:
                self.contentMode = .scaleAspectFit
            }
            self.image = image
        }
    }
}
