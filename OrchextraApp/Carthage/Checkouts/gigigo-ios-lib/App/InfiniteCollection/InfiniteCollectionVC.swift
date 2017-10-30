//
//  InfiniteCollectionVC.swift
//  GIGLibrary
//
//  Created by Jerilyn Goncalves on 10/04/2017.
//  Copyright © 2017 Gigigo SL. All rights reserved.
//

import UIKit

class InfiniteCollectionVC: UIViewController {

    @IBOutlet weak var infiniteCollectionView: InfiniteCollectionView!
    
    let numberOfItems = 3
    let colors = [#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupCollection()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupCollection() {
        self.infiniteCollectionView.register(InfiniteCollectionViewCell.self, forCellWithReuseIdentifier: "testCellIdentifier")
        self.infiniteCollectionView.infiniteDataSource = self
        self.infiniteCollectionView.infiniteDelegate = self
    }

}

// MARK: - InfiniteCollectionViewDataSource

extension InfiniteCollectionVC: InfiniteCollectionViewDataSource {
    
    func cellForItemAtIndexPath(collectionView: UICollectionView, dequeueIndexPath: IndexPath, usableIndexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = infiniteCollectionView.dequeueReusableCell(withReuseIdentifier: "testCellIdentifier", for: dequeueIndexPath) as? InfiniteCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setSize(cellSize())
        cell.setup(with: "Row \(usableIndexPath.row)")
        cell.backgroundColor = self.colors[usableIndexPath.row]
        return cell
    }
    
    func numberOfItems(collectionView: UICollectionView) -> Int {
        
        return numberOfItems
    }
    
    func cellSize() -> CGSize {
        
        let cellSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        return cellSize
    }
}

// MARK: - InfiniteCollectionViewDelegate

extension InfiniteCollectionVC: InfiniteCollectionViewDelegate {
    
    func didSelectCellAtIndexPath(collectionView: UICollectionView, indexPath: IndexPath) {
        
        Log("Selected cell at row: \(indexPath.row)")
    }
    
    func didDisplayCellAtIndexPath(collectionView: UICollectionView, dequeueIndexPath: IndexPath, usableIndexPath: IndexPath, movedForward: Bool) {
        
        Log("Currently displaying cell at row: \(usableIndexPath.row)")
    }
    
    func didEndDisplayingCellAtIndexPath(collectionView: UICollectionView, dequeueIndexPath: IndexPath, usableIndexPath: IndexPath) {
        
        Log("Dissapeared from display cell at row: \(usableIndexPath.row)")
    }
}
