//
//  GifCollectionViewCell.swift
//  Giffy Keyboard
//
//  Created by Nisha  on 04/11/18.
//  Copyright © 2018 Nisha . All rights reserved.
//

import UIKit

class GifCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    func setGif(urlString: String) {
        let gifImage = UIImage.gif(url: urlString)
        imageView.image = gifImage
    }
}
