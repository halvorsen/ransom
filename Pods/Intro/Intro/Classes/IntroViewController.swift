//
//  IntroViewController.swift
//  Pods
//
//  Created by Nurdaulet Bolatov on 12/22/16.
//
//

import UIKit

public enum IntroAnimationType {
    case raise
    case rotate
}

public class IntroViewController: UIViewController {

    public var animationType = IntroAnimationType.rotate

    public var items: [(String, UIImage?)]!

    public var titleColor = UIColor.black
    public var titleFont = UIFont(name: "HelveticaNeue", size: 16)

    public var imageContentMode = UIViewContentMode.center //.scaleAspectFit

    public var closeTitle: String!
    public var closeColor = UIColor.white
    public var closeBackgroundColor = UIColor.black
    public var closeBorderWidth: CGFloat = 0
    public var closeBorderColor: CGColor = UIColor.black.cgColor
    public var closeCornerRadius: CGFloat = 2
    public var didClose: (() -> Void)? = nil

    fileprivate var prevIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    fileprivate let flowLayout = UICollectionViewFlowLayout()
    fileprivate var collectionView: UICollectionView?

    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.8)
        view.alpha = 0.9
        edgesForExtendedLayout = UIRectEdge()
        configureFlowLayout()
        configureCollectionView()
    }

    fileprivate func configureFlowLayout() {
        flowLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
    }

    fileprivate func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        guard let collectionView = collectionView else { return }
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(IntroRaiseCollectionViewCell.self, forCellWithReuseIdentifier:
            IntroRaiseCollectionViewCell.identifier)
        collectionView.register(IntroRotateCollectionViewCell.self, forCellWithReuseIdentifier:
            IntroRotateCollectionViewCell.identifier)
        view.addSubview(collectionView)

        let top = NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal,
                                     toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy: .equal,
                                      toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal,
                                        toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy: .equal,
                                       toItem: view, attribute: .right, multiplier: 1, constant: 0)
        view.addConstraints([top, left, bottom, right])
    }

    @objc fileprivate func close(_ button: UIButton) {
        dismiss(animated: true) {
            self.didClose?()
        }
    }

}

extension IntroViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: IntroCollectionViewCellAnimatable = {
            switch animationType {
            case .raise:
                return collectionView.dequeueReusableCell(withReuseIdentifier:
                        IntroRaiseCollectionViewCell.identifier, for: indexPath)
                        as! IntroRaiseCollectionViewCell
            case .rotate:
                return collectionView.dequeueReusableCell(withReuseIdentifier:
                        IntroRotateCollectionViewCell.identifier, for: indexPath)
                        as! IntroRotateCollectionViewCell
            }
        }()

        cell.textLabel.text = items[indexPath.item].0
        cell.textLabel.textColor = titleColor
        cell.textLabel.font = titleFont

        cell.imageView.image = items[indexPath.item].1
        cell.imageView.contentMode = imageContentMode
        
        cell.closeButton.setTitle(closeTitle, for: .normal)
        cell.closeButton.setTitleColor(closeColor, for: .normal)
        cell.closeButton.backgroundColor = closeBackgroundColor
        cell.closeButton.layer.borderWidth = closeBorderWidth
        cell.closeButton.layer.borderColor = closeBorderColor
        cell.closeButton.layer.cornerRadius = closeCornerRadius
        cell.closeButton.addTarget(self, action: #selector(IntroViewController.close(_:)), for: .touchUpInside)
        cell.isCloseButtonHidden = (indexPath.item != items.count - 1)
        return cell as! UICollectionViewCell
    }

}

extension IntroViewController: UICollectionViewDelegate, UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cellWidth = flowLayout.estimatedItemSize.width
        let progress = scrollView.contentOffset.x.truncatingRemainder(dividingBy: cellWidth) / cellWidth * 100
        prevIndexPath.row = Int(scrollView.contentOffset.x) / Int(cellWidth)
        if let cell = collectionView?.cellForItem(at: prevIndexPath) as? IntroCollectionViewCellAnimatable {
            cell.animateLeft(progress: progress)
        }
        let nextIndexPath = IndexPath(item: prevIndexPath.item + 1, section: prevIndexPath.section)
        if let cell = collectionView?.cellForItem(at: nextIndexPath) as? IntroCollectionViewCellAnimatable {
            cell.animateRight(progress: progress)
        }
    }
    
}
