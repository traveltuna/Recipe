//
//  RecipeDetailsViewController.swift
//  Recipe
//
//  Created by Fangwei Hsu on 2021/07/21.
//

import SDWebImage
import UIKit

final class RecipeDetailsViewController: UIViewController {
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    private var viewModel: RecipeViewModel!
    private var onTapFavoriteButton: () -> Void = {}
    
    static func instance(with viewModel: RecipeViewModel,
                         onTap: @escaping () -> Void) -> RecipeDetailsViewController {
        let storyboard = UIStoryboard(name: "RecipeDetails", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! RecipeDetailsViewController
        vc.viewModel = viewModel
        vc.onTapFavoriteButton = onTap
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
}

// MARK: Private Methods
private extension RecipeDetailsViewController {
    func setupAppearance() {
        thumbnailImageView.sd_setImage(with: URL(string: viewModel.thumbnailURL)) { [weak self] image, error, _, _ in
            if error != nil {
                self?.thumbnailImageView.image = UIImage(named: "placeholder")
            } else {
                self?.thumbnailImageView.image = image
            }
        }
        titleLabel.text = viewModel.title
        setupFavoriteButton()
    }
    
    func setupFavoriteButton() {
        let tintedImage = (viewModel.isFavorite ? UIImage(named: "likeSolid") : UIImage(named: "like"))?.withRenderingMode(.alwaysTemplate)
        let imageButton = UIButton(type: .custom)
        imageButton.setBackgroundImage(tintedImage, for: .normal)
        imageButton.tintColor = .red
        imageButton.addTarget(self,
                              action: #selector(didTapFavoriteButton),
                              for: .touchUpInside)
        let favoriteButton = UIBarButtonItem(customView: imageButton)
        favoriteButton.customView?.heightAnchor.constraint(equalToConstant: 25).isActive = true
        favoriteButton.customView?.widthAnchor.constraint(equalToConstant: 25).isActive = true
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    @objc func didTapFavoriteButton() {
        viewModel = RecipeViewModel(with: Recipe(id: viewModel.id,
                                                 attributes: RecipeAttributes(title: viewModel.title,
                                                                              thumbnailURL: viewModel.thumbnailURL)),
                                    isFavorite: !viewModel.isFavorite)
        setupFavoriteButton()
        let alert = UIAlertController(title: "???????????????",
                                      message: viewModel.isFavorite ? "??????????????????" : "??????????????????",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        onTapFavoriteButton()
    }
}
