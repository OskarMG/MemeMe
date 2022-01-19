//
//  SentMemesCollectionVC.swift
//  MemeMe
//
//  Created by Oscar Martínez Germán on 19/1/22.
//

import UIKit


class SentMemesCollectionVC: UICollectionViewController {
    
    // MARK: - Properties
    let space: CGFloat = 3.0
    let padding: CGFloat = 20.0
    let cellHeight: CGFloat = 150
    var cellWith: CGFloat { return (self.view.frame.size.width - (2 * space)) / 3.0 }
    
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.configureFlowLayout()
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.configureFlowLayout()
     }
    
    func configureFlowLayout() {
        DispatchQueue.main.async {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: self.cellWith, height: self.cellHeight)
            layout.minimumLineSpacing = self.space
            layout.minimumInteritemSpacing = self.space
            self.collectionView.collectionViewLayout = layout
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async { self.collectionView.reloadData() }
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SentMemesCollectionViewCell.identifier, for: indexPath) as! SentMemesCollectionViewCell
        let meme = self.memes[indexPath.row]
        cell.configureCell(with: meme)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let memeDetailVC = storyboard?.instantiateViewController(withIdentifier: MemeDetailVC.identifier) as! MemeDetailVC
        let meme = self.memes[indexPath.row]
        memeDetailVC.meme = meme
        
        self.navigationController?.pushViewController(memeDetailVC, animated: true)
    }

}

extension SentMemesCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cellWith, height: self.cellHeight)
    }
}
