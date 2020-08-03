import UIKit

//MARK: -Goals
//GET all categories
//GET all API's for a specific category

let baseURL = URL(string: "https://api.publicapis.org")

//MARK: -Model file because its out data for our Model
//Model 1 (potentially?)
//This is for the "api.publicapis.org/categories"
struct TopLevelObject {
  let entries: [String]
}
//for the url "api.publicapis.org/entries"
struct TopLevelObject2 {
  let count: Int
  let entries: [Entry] //We want our Array to be an Array of Entry Objects
}

struct Entry {
  let API: String
  let Description: String
  let Auth: String
  let HTTPS: Bool
  let Cors: String
  let Link: String
  let Category: String
}
