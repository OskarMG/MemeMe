//
//  SentMemesTableViewCell.swift
//  MemeMe
//
//  Created by Oscar Martínez Germán on 19/1/22.
//

import UIKit

class SentMemesTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "SentMemesTableViewCell"
    
    @IBOutlet weak var memedImageView: UIImageView!
    @IBOutlet weak var memeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(with meme: Meme) {
        DispatchQueue.main.async {
            self.memedImageView.image = meme.memedImage
            self.memeLabel.text = "\(meme.topText)...\(meme.bottomText)"
        }
    }

}
