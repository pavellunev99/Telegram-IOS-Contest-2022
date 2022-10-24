//
//  SelectPhotoCell.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 09.10.2022.
//

import UIKit

final class SelectPhotoCell: UICollectionViewCell {

    let imageView = UIImageView()

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.masksToBounds = true

        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
