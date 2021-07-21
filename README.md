# Recipe

### Environment

Xcode 12.5, deployment target 14.5, written in Swift

### Setup
1. `git clone git@github.com:traveltuna/Recipe.git`
2. Go to the directory and type `pod install`


### Overview
The initial screen is `TabViewController`, which consists of two tabs (`RecipeGridViewController`, `FavoriteGridViewController`). Tapping the collection view cell inside `RecipeGridViewController` will transit to the details screen of the selected recipe (`RecipeDetailsViewController`). `RecipeGridViewController` and `FavoriteGridViewController` both use `UICollectionViewFlowLayout` to specify the desired layout.

### Logic
`RecipeViewModel` contains the info from server side (id, thumbnail and title) and a boolean `isFavorite` which indicates whether the recipe is liked or not. Collections views and details screen render their UI based on an array of `RecipeViewModel`. Since we need to maintain the favorite status in the whole app, we create a singleton class `DataManager` to help us manage the data. The explanation of three variables in `DataManager` is as follows:

- `favoriteRecipes`: an array of `RecipeViewModel`. `FavoriteGridViewController` renders its UI based on this variable. It is arranged in descending order.
- `favoriteRecipeIds`: an array of `String` which represents the ids of `favoriteRecipes`. We use `UserDefaults` to store this variable so that we can maintain the favorite status even when we kill the app and relaunch. In real-life situation, we may rely on server side to fetch the list of favorite recipes and `UserDefaults` approach is not necessary.
- `favoriteDict`: a dictionary which maps the id (`String`) to the `RecipeViewModel`. In order to display data in `FavoriteGridViewController` at first launch, we create `favoriteDict` when we fetchthe data from demo API and then map `favoriteRecipeIds` to `favoriteRecipes`. 
