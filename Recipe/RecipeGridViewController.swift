//
//  RecipeGridViewController.swift
//  Recipe
//
//  Created by Fangwei Hsu on 2021/07/17.
//

import UIKit

final class RecipeGridViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    private var recipeViewModel = RecipeViewModel(data: [Recipe]())
    
    static func instance() -> RecipeGridViewController {
        let storyboard = UIStoryboard(name: "RecipeGrid", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! RecipeGridViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "献立"
        registerCells()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recipeViewModel.fetchRecipes { [weak self] model, error in
            if let error = error {
                let alert = UIAlertController(title: "Error",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                DispatchQueue.main.async {
                    self?.present(alert, animated: true, completion: nil)
                }
            } else if let model = model {
                self?.recipeViewModel = model
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
}

// MARK: Private Methods
private extension RecipeGridViewController {
    struct Constants {
        static let horizontalInset: CGFloat = 12.0
        static let verticalInset: CGFloat = 12.0
        static let minimumLineSpacing: CGFloat = 24.0
        static let titleHeight: CGFloat = 70.0
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
extension RecipeGridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeViewModel.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let recipeCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier,
                                                            for: indexPath) as! RecipeCollectionViewCell
        recipeCell.configureCell(with: recipeViewModel.data[indexPath.item])
        return recipeCell
    }
}

// MARK: UICollectionViewDelegateFlowLayout Methods
extension RecipeGridViewController: UICollectionViewDelegateFlowLayout {
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
