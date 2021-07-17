//
//  Recipe.swift
//  Recipe
//
//  Created by Fangwei Hsu on 2021/07/17.
//

import Foundation

struct RecipeResponse: Codable {
    let data: [Recipe]
}

struct Recipe: Codable {
    let id: String
    let attributes: RecipeAttributes
}

struct RecipeViewModel {
    let id: String
    let title: String
    let thumbnailURL: String
    let isFavorite: Bool
    
    init(with recipe: Recipe, isFavorite: Bool) {
        self.id = recipe.id
        self.title = recipe.attributes.title
        self.thumbnailURL = recipe.attributes.thumbnailURL
        self.isFavorite = isFavorite
    }
}

struct RecipeAttributes: Codable {
    let title: String
    let thumbnailURL: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case thumbnailURL = "thumbnail-square-url"
    }
}
