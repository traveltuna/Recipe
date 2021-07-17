//
//  RecipeViewModel.swift
//  Recipe
//
//  Created by Fangwei Hsu on 2021/07/17.
//

import Foundation

struct RecipeViewModel: Codable {
    let data: [Recipe]
    
    func fetchRecipes(completionHandler: @escaping (RecipeViewModel?, Error?) -> Void) {
        let url = URL(string: "https://s3-ap-northeast-1.amazonaws.com/data.kurashiru.com/videos_sample.json")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
//            if let returnData = String(data: data!, encoding: .utf8) {
//                print(returnData)
//            }
            if let data = data,
               let repositoryViewModel = try? JSONDecoder().decode(RecipeViewModel.self, from: data) {
                completionHandler(repositoryViewModel, nil)
            }
        })
        task.resume()
    }
}
