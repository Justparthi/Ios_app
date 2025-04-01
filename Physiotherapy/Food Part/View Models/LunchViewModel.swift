//
//  LunchViewModel.swift
//  Physiotherapy
//
//  Created by Yash Patil on 25/11/23.
//

import Foundation
import SwiftUI
import Combine

@Observable
class LunchViewModel: ObservableObject {
   
    static let shared = LunchViewModel()
    static let APIKey = "16BPm6TsGFIZGFxln"
    
    var foodItems: [Item] = []
    
    var cancellable = Set<AnyCancellable>()
    
    let itemKey = "LunchItems"
    var quantity: Int = 0
    
    var items: [Item] = [] {
        didSet {
            saveItems()
        }
    }
    
    var gotoNutrition: Bool = false

    init() {
        getItems()
    }
    
    func getItems() {
        if let data = UserDefaults.standard.data(forKey: itemKey),
           let items = try? JSONDecoder().decode([Item].self, from: data) {
            self.items.append(contentsOf: items)
        }
    }
    
    func saveItems() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: itemKey)
        }else {
            print("Error encoding items")
        }
    }
    
    func add(item: Item, grams: Int) {
        var newItem = item
        newItem.grams = grams
        self.items.append(newItem)
    }
    
    func fetchDataFromAPI(foodName: String, retryCount: Int = 3, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL.foodURLby(name: foodName) else {
            // Handle the case where the URL cannot be constructed
            completion(nil, NSError(domain: "YourDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        // Create a URL request with caching
            var request = URLRequest(url: url)
            request.cachePolicy = .returnCacheDataElseLoad
        
        URLSession.shared.dataTask(with: url) { [self] data, response, error in
                if let error = error {
                    // Handle the network error
                    completion(nil, error)
                    return
                }

                guard let data = data else {
                    // Handle the case where the data is nil
                    completion(nil, NSError(domain: "YourDomain", code: 2, userInfo: [NSLocalizedDescriptionKey: "Empty Data"]))
                    return
                }

            do {
                let decodedData = try JSONDecoder().decode(FoodItems.self, from: data)

                if !decodedData.items.isEmpty {
                    // Handle the case where "items" key is present
                    self.foodItems = decodedData.items
                    completion(data, nil)
                    
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                                let cacheResponse = CachedURLResponse(response: httpResponse, data: data ?? Data())
                                URLCache.shared.storeCachedResponse(cacheResponse, for: request)
                            }
                    
                } else {
                    // Handle the case where "items" key is empty or not present
                    print("Warning: No or empty 'items' key found in the JSON response.")
                    completion(nil, NSError(domain: "YourDomain", code: 4, userInfo: [NSLocalizedDescriptionKey: "No or empty 'items' key"]))
                }

            } catch {
                print("Decoding error: \(error)")

                // Retry the request with increasing delay
                if retryCount > 0 {
                    let retryDelay = Double(3 - retryCount) // Increase delay with each retry
                    print("Retrying request with delay \(retryDelay) seconds...")

                    DispatchQueue.main.asyncAfter(deadline: .now() + retryDelay) {
                        fetchDataFromAPI(foodName: foodName, retryCount: retryCount - 1, completion: completion)
                    }
                } else {
                    // Retry limit reached, provide an error
                    completion(nil, NSError(domain: "YourDomain", code: 3, userInfo: [NSLocalizedDescriptionKey: "Retry limit reached"]))
                }
            }

            }.resume()
        
        let _ = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: FoodItems.self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("error: \(error)")
                }
            } receiveValue: { [weak self] foodItems in
                guard let self else {return }
                self.foodItems = foodItems.items
              //  items = foodItems.items
            }
            .store(in: &cancellable)

       // return items
    }
    
}
