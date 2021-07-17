//
//  FavoriteGridViewController.swift
//  Recipe
//
//  Created by Fangwei Hsu on 2021/07/17.
//

import UIKit

final class FavoriteGridViewController: UIViewController {
    @IBOutlet private weak var header: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    static func instance() -> FavoriteGridViewController {
        let storyboard = UIStoryboard(name: "FavoriteGrid", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! FavoriteGridViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "お気に入り"
        registerCells()
        setupLayout()
    }
}

// MARK: Private Methods
private extension FavoriteGridViewController {
    struct Constants {
        static let horizontalInset: CGFloat = 12.0
        static let verticalInset: CGFloat = 12.0
        static let minimumLineSpacing: CGFloat = 24.0
        static let titleHeight: CGFloat = 50.0
    }
    
    func registerCells() {
        collectionView.register(UINib(nibName: RecipeCollectionViewCell.className, bundle: nil),
                                forCellWithReuseIdentifier: RecipeCollectionViewCell.identifier)
    }
    
    func setupLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        layout.minimumInteritemSpacing = Constants.horizontalInset
        collectionView.collectionViewLayout = layout
    }
}

// MARK: UICollectionViewDataSource Methods
extension FavoriteGridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let recipeCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier,
                                                            for: indexPath)
        return recipeCell
    }
}

// MARK: UICollectionViewDelegateFlowLayout Methods
extension FavoriteGridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.verticalInset,
                            left: Constants.horizontalInset,
                            bottom: Constants.verticalInset,
                            right: Constants.horizontalInset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - Constants.horizontalInset * 3) / 2
        return CGSize(width:width, height:width + Constants.titleHeight)
    }
}
