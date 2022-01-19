//
//  SentMemesCollectionViewCell.swift
//  MemeMe
//
//  Created by Oscar Martínez Germán on 19/1/22.
//

import UIKit

class SentMemesCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "SentMemesCollectionViewCell"
    @IBOutlet weak var memedImageView: UIImageView!
    @IBOutlet weak var memeLabel: UILabel!
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - CollectionView Methods
    func configureCell(with meme: Meme) {
        DispatchQueue.main.async {
            self.memedImageView.image = meme.memedImage
            self.memeLabel.text = "\(meme.topText)...\(meme.bottomText)"
        }
    }
}
