import UIKit

//MARK: -Goals
//GET all categories
//GET all API's for a specific category
/*
 This will generally always go into the controller
 let baseURL = URL(string: "https://api.publicapis.org")
 */
//MARK: -Model file because its out data for our Model
//Model 1 (potentially?)
//This is for the "api.publicapis.org/categories"

//struct TopLevelObject: Codable {
//  let entries: [String]
//}
//for the url "api.publicapis.org/entries"
struct TopLevelObject: Codable {
  let count: Int
  let entries: [Entry] //We want our Array to be an Array of Entry Objects
}
//This is the breakdown of the Array of "Entry"
struct Entry: Codable {
  let API: String
  let Description: String
  let Auth: String
  let HTTPS: Bool
  let Cors: String
  let Link: String
  let Category: String
}

//MARK: -Model controller - Always a class

class EntryController {
  static let baseURL = URL(string: "https://api.publicapis.org")
  static let catergoriesEndpoint = "categories"
  static let entriesEndpoint = "entries"
  
  
 static func fetchAllCategories(completion: @escaping ([String]) -> Void) {
    //Creates the baseURL
    guard let baseURL = baseURL else { return completion([]) }
    //now I need to append any component I need to get to the desired Endpoint
    let categoriesURL = baseURL.appendingPathComponent(catergoriesEndpoint)
    print(categoriesURL)
    
    URLSession.shared.dataTask(with: categoriesURL) { (data, _, error) in
      //Check if there was indeed an error
      if let error = error {
        print("\n\n\n+++++++++++++====================++++++++++++")
        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        print("\n\n\n+++++++++++++====================++++++++++++")
        return completion([])
      } else {
        //Check if the data exists if not return our completion of an Empty array
        guard let data = data else { return completion([]) }
        //Decode that data
        do {
          //give me my dedcoded categoires by trying to decode the data we got back
          let categories = try JSONDecoder().decode([String].self, from: data)
          return completion(categories)
        } catch {
          print("\n\n\n+++++++++++++====================++++++++++++")
          print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
          print("\n\n\n+++++++++++++====================++++++++++++")
          return completion([])
        } //End of Do - Catch statement
      } //End of if let
    }.resume() //End of URL Sessions so we need to "start" the task
  } //End of fetchAllCategories
  //https://api.publicapis.org/entries?category=news
  
  static func fetchEntries(for category: String, completion: @escaping ([Entry]) -> Void ) {
    //Build the URL
    //First create the baseURL if it doesn't exist return an empty complettion block
    guard let baseURL = baseURL else { return completion([]) }
    //second build the base URL with the endPoint
    let entriesURL = baseURL.appendingPathComponent(entriesEndpoint)
    //third create a URLComponents property so that we can get access to queryItems
    var components = URLComponents(url: entriesURL, resolvingAgainstBaseURL: true)
    //Fourth call that components with the queryItems property and set that to an Array of URLQueryItems
    //Pasing in the first part, and then the item in which we are searching/querying for.
    components?.queryItems = [URLQueryItem(name: "category", value: category)]
    //Fifth bulld the final URL to be used to get what we want
    guard let finalURL = components?.url else {return}
    print(finalURL)
    
    //Fetch the data
    URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
      //Check for errors
      if let error = error {
        print("\n\n\n+++++++++++++====================++++++++++++")
        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        print("\n\n\n+++++++++++++====================++++++++++++")
        return completion([])
      }
      //Check for Data
      guard let data = data else { return completion([])}
      //decode the data with a do try block
      do {
        let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
        let entries = topLevelObject.entries
        return completion(entries)
      } catch {
        print("\n\n\n+++++++++++++====================++++++++++++")
        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        print("\n\n\n+++++++++++++====================++++++++++++")
        return completion([])
      }
    }.resume() //End of URLSession and start Network call by resuming it
  } //End of FetchEntries
} //End of Class
print("\n\n\n***********====================*************")
EntryController.fetchAllCategories { (categories) in
//  for cat in categories {
//    print(cat)
//  }
print("\n\n\n~~~~~~~~~~~~~~====================~~~~~~~~~~~~~~~~~~~")
  //another way of doing the for loop
  categories.forEach{ cat in print(cat)}
}

print("\n\n\n###############====================###############")

EntryController.fetchEntries(for: "Art & Design") { (entries) in
  for entry in entries {
    print("""
      - - - - - - - - - - - - - - -
      Name: \(entry.API)
      Desc: \(entry.Description)
      Category: \(entry.Category)
      Link: \(entry.Link)
      Auth: \(entry.Auth)
      Cors: \(entry.Cors)
      https: \(entry.HTTPS)
      
      """)
  }
}
