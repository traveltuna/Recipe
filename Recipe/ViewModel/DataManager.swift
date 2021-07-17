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
    var favoriteRecipeIds = ["baaec62c-2603-4269-ac0f-0e9ee7273401", "c1f916be-ce00-4fc8-928f-038320cff676"]
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
}
