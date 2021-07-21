//
//  RecipeCollectionViewCell.swift
//  Recipe
//
//  Created by Fangwei Hsu on 2021/07/17.
//

import RxSwift
import SDWebImage
import UIKit

final class RecipeCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        disposeBag = DisposeBag()
    }
    
    func configureCell(with recipe: RecipeViewModel, showLikeButton: Bool) {
        configureTitleLabel(with: recipe.title, lineHeightMultiple: 1.5)
        titleLabel.text = recipe.title
        thumbnailImageView.sd_setImage(with: URL(string: recipe.thumbnailURL)) { [weak self] image, error, _, _ in
            if error != nil {
                self?.thumbnailImageView.image = UIImage(named: "placeholder")
            } else {
                self?.thumbnailImageView.image = image
            }
        }
        
        if showLikeButton {
            likeButton.isHidden = false
            let tintedImage = (recipe.isFavorite ? UIImage(named: "likeSolid") : UIImage(named: "like"))?.withRenderingMode(.alwaysTemplate)
            likeButton.setImage(tintedImage, for: .normal)
            likeButton.tintColor = .red
        } else {
            likeButton.isHidden = true
        }
    }
}

private extension RecipeCollectionViewCell {
    func configureTitleLabel(with text: String, lineHeightMultiple: CGFloat) {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.font,
                                      value: UIFont.boldSystemFont(ofSize: 14),
                                      range: NSMakeRange(0, attributedString.length))
        titleLabel.attributedText = attributedString
    }
}
