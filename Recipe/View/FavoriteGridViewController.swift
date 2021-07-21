//
//  FavoriteGridViewController.swift
//  Recipe
//
//  Created by Fangwei Hsu on 2021/07/17.
//

import RxCocoa
import RxDataSources
import RxRelay
import RxSwift
import UIKit

final class FavoriteGridViewController: UIViewController {
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    private let recipes = BehaviorRelay<[RecipeSection]>(value: [])
    private let dataSource = RxCollectionViewSectionedReloadDataSource<RecipeSection>(
        configureCell: { _, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier,
                                                          for: indexPath) as! RecipeCollectionViewCell
            cell.configureCell(with: item, showLikeButton: false)
            return cell
            
        }
    )
    let disposeBag = DisposeBag()
    
    static func instance() -> FavoriteGridViewController {
        let storyboard = UIStoryboard(name: "FavoriteGrid", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! FavoriteGridViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "お気に入り"
        setupCountLable()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recipes.accept([RecipeSection(recipes: DataManager.shared.favoriteRecipes)])
    }
}

// MARK: Private Methods
private extension FavoriteGridViewController {
    struct Constants {
        static let horizontalInset: CGFloat = 12.0
        static let verticalInset: CGFloat = 12.0
        static let minimumLineSpacing: CGFloat = 24.0
        static let titleHeight: CGFloat = 70.0
    }
    
    func setupCountLable() {
        recipes.asObservable().subscribe(onNext: { [weak self] vm in
            self?.countLabel.text = "お気に入り件数 \(vm.first?.items.count ?? 0)"
        }).disposed(by: disposeBag)
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        recipes.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        collectionView.register(UINib(nibName: RecipeCollectionViewCell.className, bundle: nil),
                                forCellWithReuseIdentifier: RecipeCollectionViewCell.identifier)
        setupCollectionViewLayout()
    }

    func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        layout.minimumInteritemSpacing = Constants.horizontalInset
        collectionView.collectionViewLayout = layout
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
        return CGSize(width: width, height: width + Constants.titleHeight)
    }
}
