//
//  DataManager.swift
//  Recipe
//
//  Created by Fangwei Hsu on 2021/07/17.
//

import Foundation

final class DataManager {
    static let shared = DataManager()
    var favoriteRecipes = [RecipeViewModel]()
    var favoriteRecipeIds = UserDefaults.standard.stringArray(forKey: UserDefaultsKeys.favoriteRecipeIds) ?? [String]()
    var favoriteDict = [String: RecipeViewModel]()
    
    func fetchRecipes(completionHandler: @escaping ([RecipeViewModel]?, Error?) -> Void) {
        let url = URL(string: "https://s3-ap-northeast-1.amazonaws.com/data.kurashiru.com/videos_sample.json")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { [unowned self] (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            if let data = data,
               let response = try? JSONDecoder().decode(RecipeResponse.self, from: data) {
                var ar = [RecipeViewModel]()
                let favoriteSet = Set(favoriteRecipeIds)
                for recipe in response.data {
                    if favoriteSet.contains(recipe.id) {
                        let vm = RecipeViewModel(with: recipe, isFavorite: true)
                        ar.append(vm)
                        favoriteDict[recipe.id] = vm
                    } else {
                        ar.append(RecipeViewModel(with: recipe, isFavorite: false))
                    }
                }
                var favoriteArrays = [RecipeViewModel]()
                for id in favoriteRecipeIds {
                    if let vm = favoriteDict[id] {
                        favoriteArrays.append(vm)
                    }
                }
                favoriteRecipes = favoriteArrays
                completionHandler(ar, nil)
            }
        })
        task.resume()
    }
    
    func updateFavoriteStatus(with viewModel: RecipeViewModel) {
        if viewModel.isFavorite {
            // like the recipe
            favoriteRecipes = favoriteRecipes.filter { $0.id != viewModel.id }
            favoriteRecipes = [viewModel] + favoriteRecipes
            favoriteRecipeIds = favoriteRecipes.map { $0.id }
            favoriteDict[viewModel.id] = viewModel
        } else {
            // unlike the recipe
            favoriteDict[viewModel.id] = nil
            favoriteRecipes = favoriteRecipes.filter { $0.id != viewModel.id }
            favoriteRecipeIds = favoriteRecipes.map { $0.id }
        }
        UserDefaults.standard.setValue(favoriteRecipeIds, forKey: UserDefaultsKeys.favoriteRecipeIds)
    }
    
    struct UserDefaultsKeys {
        static let favoriteRecipeIds = "kFavoriteRecipeIds"
    }
}
