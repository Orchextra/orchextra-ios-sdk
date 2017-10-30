//
//  InfiniteCollectionView.swift
//  GIGLibrary
//
//  Created by Jerilyn Goncalves on 28/03/2017.
//  Copyright © 2017 Gigigo SL. All rights reserved.
//

import UIKit

public protocol InfiniteCollectionViewDataSource: class {
    
    /**
     Provides cell for infinite collection. Works just like the regular `cellForItemAtIndexPath`, however, consumer
     should use `dequeueIndexPath` for dequeuing the cell and `usableIndexPath` for the cell content.
     
     - Parameter collectionView: The collection view.
     - Parameter dequeueIndexPath: The index path for dequeuing the reusable cell.
     - Parameter usableIndexPath: The index path for the cell's content.
     
     - Returns: The cell.
    */
    func cellForItemAtIndexPath(collectionView: UICollectionView, dequeueIndexPath: IndexPath, usableIndexPath: IndexPath) -> UICollectionViewCell
    
    /**
     Provides the number of items for infinite collection.
     
     - Parameter collectionView: The collection view.
     
     - Returns: The number of elements.
    */
    func numberOfItems(collectionView: UICollectionView) -> Int
    
    /**
     Provides the size for items in the infinite collection.
     
     - Returns: Size for cells.
     */
    func cellSize() -> CGSize

}

public protocol InfiniteCollectionViewDelegate: class {
    
    /**
     Notifies that a cell has been selected.
     
     - Parameter collectionView: The collection view.
     - Parameter usableIndexPath: The index path for the selected cell.     
     */
    func didSelectCellAtIndexPath(collectionView: UICollectionView, indexPath: IndexPath)
  
    /**
     Notifies that a cell is displayed on screen.
     Note that this method is triggered only if the cell is *fully displayed*
     
     - Parameter collectionView: The collection view.
     - Parameter dequeueIndexPath: The index path for dequeuing the reusable cell.
     - Parameter usableIndexPath: The index path for the cell.
     - Parameter movedForward: Flag for scroll direction, 'true' when it's moving forward, 'false' when it's moving backwards
     */
    func didDisplayCellAtIndexPath(collectionView: UICollectionView, dequeueIndexPath: IndexPath, usableIndexPath: IndexPath, movedForward: Bool)
    
    /**
     Notifies that a cell will no longer be displayed on screen.

     - Parameter collectionView: The collection view.
     - Parameter dequeueIndexPath: The index path for dequeuing the reusable cell.
     - Parameter usableIndexPath: The index path for the cell.
    */
    func didEndDisplayingCellAtIndexPath(collectionView: UICollectionView, dequeueIndexPath: IndexPath, usableIndexPath: IndexPath)

}

/// UICollectionView with infinite paginated scroll
open class InfiniteCollectionView: UICollectionView {

    // MARK: Public attributes
    
    weak open var infiniteDataSource: InfiniteCollectionViewDataSource?
    weak open var infiniteDelegate: InfiniteCollectionViewDelegate?
    override open var dataSource: UICollectionViewDataSource? {
        didSet {
            guard let dataSource = self.dataSource else { return }
            if !dataSource.isEqual(self) {
                self.dataSource = self
            }
        }
    }
    override open var delegate: UICollectionViewDelegate? {
        didSet {
            guard let delegate = self.delegate else { return }
            if !delegate.isEqual(self) {
                self.delegate = self
            }
        }
    }
    
    open fileprivate(set) var isMovingForward = true

    // MARK: Private attributes
    
    fileprivate var loaded = false
    fileprivate var cellWidth = CGFloat(0)
    fileprivate var indexOffset = 0
    fileprivate var lastVisibleIndexPath = IndexPath(row: 0, section: 0)
    fileprivate var lastVisibleUsableIndexPath = IndexPath(row: 0, section: 0)
    fileprivate var lastContentOffsetX: CGFloat?
    
    // MARK: - Initializer
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dataSource = self
        delegate = self
        setup()
    }
    
    // MARK: - Life cycle
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        centreIfNeeded()
    }
    
    // MARK: - Public methods
    
    open func displayNext() {
        if let visibleIndexPath = indexPathsForVisibleItems.last {
            let nextIndexPath = IndexPath(row: visibleIndexPath.row + 1, section: 0)
            scrollToItem(at: nextIndexPath, at: .left, animated: true)
        }
    }
    
    // MARK: - Private methods
    
    // MARK: UI setup
    
    private func setup() {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            cellWidth = layout.itemSize.width
        }
        isPagingEnabled = true
        bounces = false
        decelerationRate = UIScrollViewDecelerationRateFast
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    // MARK: Helpers
    
    private func centreIfNeeded() {
        guard getNumberOfItems() > 0 else {
            return
        }
        let currentOffset = contentOffset
        let contentWidth = CGFloat(getNumberOfItems()) * cellWidth
        // Calculate the centre of content X position offset and the current distance from that centre point
        let centerOffsetX: CGFloat = (3 * contentWidth - bounds.size.width) / 2
        let distFromCentre = centerOffsetX - currentOffset.x
        if fabs(distFromCentre) > (contentWidth / 4) {
            // Total cells (including partial cells) from centre
            let cellcount = distFromCentre/cellWidth
            // Amount of cells to shift (whole number) - conditional statement due to nature of +ve or -ve cellcount
            let shiftCells = Int((cellcount > 0) ? floor(cellcount) : ceil(cellcount))
            // Amount left over to correct for
            let offsetCorrection = (abs(cellcount).truncatingRemainder(dividingBy: 1)) * cellWidth
            // Scroll back to the centre of the view, offset by the correction to ensure it's not noticeable
            if contentOffset.x < centerOffsetX { //left scrolling
                contentOffset = CGPoint(x: centerOffsetX - offsetCorrection, y: currentOffset.y)
            } else if contentOffset.x > centerOffsetX { //right scrolling
                contentOffset = CGPoint(x: centerOffsetX + offsetCorrection, y: currentOffset.y)
            }
            // Make content shift as per shiftCells
            let offset = getCorrectedIndex(indexToCorrect: shiftCells)
            indexOffset += offset
            // Reload content
            self.reloadContent()
        }
    }
    
    fileprivate func reloadContent() {
        if loaded {
            reloadData()
        } else {
            // Notify when the first cell is displayed (first time)
            weak var weakSelf = self
            self.performBatchUpdates({
                weakSelf?.reloadData()
            }, completion: { (completed) in
                guard completed else { return }
                weakSelf?.loaded = true
                let visibleIndexPath = self.visibleIndexPath() ?? IndexPath(row: 0, section: 0)
                weakSelf?.infiniteDelegate?.didDisplayCellAtIndexPath(collectionView: self, dequeueIndexPath: visibleIndexPath, usableIndexPath: IndexPath(row: 0, section: 0), movedForward: true)
                weakSelf?.lastContentOffsetX = weakSelf?.contentOffset.x
            })
        }
    }
    
    fileprivate func getNumberOfItems() -> Int {
        if let numberOfItems = infiniteDataSource?.numberOfItems(collectionView: self) {
            // Hack for the infinite collection to work when looping with 3 items or less
            return numberOfItems <= 3 ?  numberOfItems * 2 : numberOfItems
        } else {
            return 0
        }
    
    }
    
    fileprivate func getCorrectedIndex(indexToCorrect: Int) -> Int {
        let numberOfItems = getNumberOfItems()
        if indexToCorrect < numberOfItems && indexToCorrect >= 0 {
            return indexToCorrect
        } else {
            let countInIndex = Float(indexToCorrect) / Float(numberOfItems)
            let flooredValue = Int(floor(countInIndex))
            let offset = numberOfItems * flooredValue
            return indexToCorrect - offset
        }
    }
    
    fileprivate func getUsableIndexPathForRow(_ row: Int) -> IndexPath {
        var row = getCorrectedIndex(indexToCorrect: row - indexOffset)
        if let numberOfItems = infiniteDataSource?.numberOfItems(collectionView: self), numberOfItems <= 3 {
            if row >= numberOfItems {
                row -= numberOfItems // Hack for the infinite collection to work when looping with 3 items or less
            }
        }
        return IndexPath(row: row, section: 0)
    }
}

// MARK: - UICollectionViewDataSource

extension InfiniteCollectionView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = getNumberOfItems()
        return  3 * numberOfItems
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dataSource = self.infiniteDataSource else { return UICollectionViewCell() }
        let cell = dataSource.cellForItemAtIndexPath(collectionView: self,
                                                     dequeueIndexPath: indexPath,
                                                     usableIndexPath: getUsableIndexPathForRow(indexPath.row))
        cell.clipsToBounds = true
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension InfiniteCollectionView: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        infiniteDelegate?.didSelectCellAtIndexPath(collectionView: collectionView,
                                                   indexPath: getUsableIndexPathForRow(indexPath.row))
    }

}

// MARK: - UIScrollViewDelegate

extension InfiniteCollectionView: UIScrollViewDelegate {
    
    // When 'scrollToItem:' is called, this delegate method is triggered
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        paginated()
    }
    
    // When the user scrolls the collection, this delegate method is triggered
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        paginated()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let savedContentOffsetX = lastContentOffsetX, !isDecelerating else {
            lastContentOffsetX = contentOffset.x
            return
        }
        if contentOffset.x > savedContentOffsetX {
            isMovingForward = true
        } else if contentOffset.x < savedContentOffsetX {
            isMovingForward = false
        }
        lastContentOffsetX = contentOffset.x
    }
    
    fileprivate func paginated() {
        guard let visibleIndexPath = self.visibleIndexPath() else {
            return
        }
        let visibleUsableIndexPath = getUsableIndexPathForRow(visibleIndexPath.row)
        if lastVisibleUsableIndexPath !=  visibleUsableIndexPath {
            infiniteDelegate?.didDisplayCellAtIndexPath(collectionView: self,
                                                        dequeueIndexPath: visibleIndexPath,
                                                        usableIndexPath: visibleUsableIndexPath,
                                                        movedForward: isMovingForward)
            infiniteDelegate?.didEndDisplayingCellAtIndexPath(collectionView: self,
                                                              dequeueIndexPath: lastVisibleIndexPath,
                                                              usableIndexPath: lastVisibleUsableIndexPath)
            lastVisibleIndexPath = visibleIndexPath
            lastVisibleUsableIndexPath = visibleUsableIndexPath
        }
    }
    
    fileprivate func visibleIndexPath() -> IndexPath? {
        let visibleRect = CGRect(origin: contentOffset, size: bounds.size)
        let visibilePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = indexPathForItem(at: visibilePoint)
        return visibleIndexPath
    }
    
    fileprivate func isVisible(indexPath: IndexPath) -> Bool {
        return self.visibleIndexPath() == indexPath
    }

}
