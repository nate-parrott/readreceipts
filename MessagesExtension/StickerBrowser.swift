//
//  StickerBrowser.swift
//  ReadReceipts
//
//  Created by Nate Parrott on 11/1/16.
//  Copyright © 2016 Nate Parrott. All rights reserved.
//

import UIKit
import Messages

class StickerBrowser: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var pager: UIPageControl? {
        didSet {
            _updatePager()
        }
    }
    
    var _setupYet = false
    func setup() {
        if !_setupYet {
            _setupYet = true
            addSubview(collectionView)
            collectionView.dataSource = self
            collectionView.register(ReceiptView.self, forCellWithReuseIdentifier: "Cell")
            collectionView.backgroundColor = UIColor.white
            collectionView.delegate = self
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.scrollDirection = .vertical
        flow.itemSize = CGSize(width: bounds.size.width-40, height: 50)
        flow.minimumLineSpacing = 0
        flow.minimumInteritemSpacing = 0
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    var receipts = [ReadReceipt]() {
        didSet {
            setup()
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return receipts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ReceiptView
        cell.receipt = receipts[indexPath.item]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        _updatePager()
    }
    
    func _updatePager() {
        if let p = pager {
            p.numberOfPages = receipts.count
            p.currentPage = max(0, min(p.numberOfPages-1, Int(round(collectionView.contentOffset.y / collectionView.bounds.size.height))))
        }
    }
}

class ReceiptView: UICollectionViewCell {
    let label = UILabel()
    let stickerView = MSStickerView()
    
    var _setupYet = false
    func setup() {
        if !_setupYet {
            _setupYet = true
            addSubview(stickerView)
            addSubview(label)
            label.backgroundColor = UIColor.white
            label.isUserInteractionEnabled = false
            clipsToBounds = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
        stickerView.frame = bounds
        stickerView.frame = CGRect(x: 0, y: -200, width: bounds.size.width, height: bounds.size.height + 400)
    }
    
    var receipt: ReadReceipt? {
        didSet {
            setup()
            if let r = receipt {
                let attrText = r.attributedString.mutableCopy() as! NSMutableAttributedString
                NSAttributedString._scale(r.attributedString, byScaleFactor: 1.5, output: attrText)
                label.attributedText = attrText
                label.textAlignment = .center
                stickerView.sticker = r.sticker
            }
        }
    }
}
