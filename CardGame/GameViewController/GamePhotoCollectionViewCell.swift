//
//  GamePhotoCollectionViewCell.swift
//  ShowtimeHomeWork
//
//  Created by Vitalii Kotivskyi on 8/21/18.
//  Copyright © 2018 epam. All rights reserved.
//

import Foundation
import UIKit

class GamePhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var photoImageView: UIImageView!

    static var reuseIdentifier: String {
        return "GamePhotoCollectionViewCell"
    }

    var isClosed: Bool = true
    var photoEntity: PhotoEntity?

    override func prepareForReuse() {
        super.prepareForReuse()
        photoEntity = nil
    }

    func setup(_ gameFieldItem: GameFieldItem) {
        isClosed = gameFieldItem.isClosed
        photoEntity = gameFieldItem.photoEntity
        photoImageView.image = photoEntity?.image

        update(with: gameFieldItem, animated: false)
    }

    func update(with gameFieldItem: GameFieldItem, animated: Bool) {
        guard let photoEntity = photoEntity else {
            return
        }
        assert(photoEntity == gameFieldItem.photoEntity)
        isClosed = gameFieldItem.isClosed

        if !animated {
            photoImageView.isHidden = isClosed
        } else {
            UIView.transition(with: contentView, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                self.photoImageView.isHidden = self.isClosed
            }, completion: nil)
        }
    }

}
