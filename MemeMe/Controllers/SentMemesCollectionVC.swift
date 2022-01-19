//
//  SentMemesCollectionVC.swift
//  MemeMe
//
//  Created by Oscar Martínez Germán on 19/1/22.
//

import UIKit


class SentMemesCollectionVC: UICollectionViewController {
    
    // MARK: - Properties
    let padding: CGFloat = 20
    
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureVC()
        self.configureFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async { self.tabBarController?.tabBar.isHidden = false }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadData()
    }
    
    //MARK: - Screen Orientation
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        //self.configureVC()
//        //self.reloadData()
//        
//        print(UIDevice.current.orientation.isPortrait ? 10.0 : 50.0, "esta portrait: ", UIDevice.current.orientation.isPortrait)
//    }
    
    
    func configureVC() {
        DispatchQueue.main.async {
            self.collectionView.contentInset = UIEdgeInsets(top: self.padding, left: self.padding, bottom: self.padding, right: self.padding)
        }
    }
    
    func configureFlowLayout() {
        DispatchQueue.main.async {
            let space: CGFloat = 3.0
            let dimension = ((self.view.frame.size.width - (2 * space)) - (self.padding * 2)) / 3.0
            
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: dimension, height: 150)
            
            layout.minimumLineSpacing = space
            layout.minimumInteritemSpacing = space
        
            self.collectionView.collectionViewLayout = layout
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async { self.collectionView.reloadData() }
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
        
    }

}

