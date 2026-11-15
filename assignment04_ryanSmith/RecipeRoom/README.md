# Recipe Room

A small SwiftUI educational app for Assignment 4. It requests recipes from
TheMealDB, decodes JSON into Swift models, displays a recipe list, and opens a
detail screen containing cooking instructions. This first version focuses on
photos, category, cuisine, and instructions; it does not display an ingredient list.



## API

Educational endpoint: https://www.themealdb.com/api/json/v1/1/search.php?s=
Documentation: https://www.themealdb.com/api.php
The `1` in the URL is the public educational test key. A blank search returns a
selection of recipes rather than the entire database. Follow the provider's
current terms before publishing to an app store. Recipes and photos belong to
their respective providers; the interface includes TheMealDB attribution.


