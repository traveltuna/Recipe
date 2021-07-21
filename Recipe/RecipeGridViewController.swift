//
//  RecipeGridViewController.swift
//  Recipe
//
//  Created by Fangwei Hsu on 2021/07/17.
//

import RxCocoa
import RxDataSources
import RxRelay
import RxSwift
import UIKit

struct RecipeSection {
    var recipes: [RecipeViewModel]
}

extension RecipeSection: SectionModelType {
    typealias Item = RecipeViewModel
    var items: [RecipeViewModel] {
        self.recipes
    }
    
    init(original: RecipeSection, items: [RecipeViewModel]) {
        self = original
    }
}

final class RecipeGridViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    private let recipes = BehaviorRelay<[RecipeSection]>(value: [])
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<RecipeSection>(
        configureCell: { [weak self] _, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier,
                                                          for: indexPath) as! RecipeCollectionViewCell
            cell.configureCell(with: item, showLikeButton: true)
            cell.likeButton.rx.tap
                .subscribe { [weak self] _ in
                    self?.updateFavoriteStatus(index: indexPath.item)
                }
                .disposed(by: cell.disposeBag)
            return cell
            
        }
    )
    private let disposeBag = DisposeBag()
    
    static func instance() -> RecipeGridViewController {
        let storyboard = UIStoryboard(name: "RecipeGrid", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! RecipeGridViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "献立"
        setupCollectionView()
        DataManager.shared.fetchRecipes { [weak self] viewModels, error in
            if let error = error {
                let alert = UIAlertController(title: "Error",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                DispatchQueue.main.async {
                    self?.present(alert, animated: true, completion: nil)
                }
            } else if let viewModels = viewModels {
                self?.recipes.accept([RecipeSection(recipes: viewModels)])
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
    
    func setupCollectionView() {
        collectionView.delegate = self
        recipes.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        collectionView.rx.modelSelected(RecipeViewModel.self)
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { recipe in
                // recipe is selected
            }).disposed(by: disposeBag)

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
    
    func updateFavoriteStatus(index: Int) {
        guard var ar = recipes.value.first?.items else {
            return
        }
        let newModel = RecipeViewModel(with: Recipe(id: ar[index].id,
                                                    attributes: RecipeAttributes(title: ar[index].title,
                                                                                 thumbnailURL: ar[index].thumbnailURL)),
                                       isFavorite: !ar[index].isFavorite)
        ar[index] = newModel
        recipes.accept([RecipeSection(recipes: ar)])
        DataManager.shared.updateFavoriteStatus(with: newModel)
        let alert = UIAlertController(title: "お気に入り",
                                      message: newModel.isFavorite ? "追加しました" : "解除しました",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
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
