//
//  Extensions.swift
//  Physiotherapy
//
//  Created by Yash Patil on 22/10/23.
//

import Foundation

extension URL {
    
    static let `default` = URL(string: "https://chompthis.com")
    
    static func foodURLby(name: String) -> Self? {
        guard let urlString = URL(string: "/api/v2/food/branded/name.php?api_key=\(BreakfastViewModel.APIKey)&name=\(name)", relativeTo: Self.default)?.absoluteString,
              let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
    static func recipeByItem(title: String) -> Self? {
        guard let urlString = URL(string: "/api/v2/recipe/search.php?api_key=\(BreakfastViewModel.APIKey)&title=\(title)", relativeTo: Self.default)?.absoluteString,
              let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
    // string: https://chompthis.com/api/v2/food/branded/name.php?api_key=16BPm6TsGFIZGFxln&name=Pizza
    // recipe: https://chompthis.com/api/v2/recipe/search.php?api_key=16BPm6TsGFIZGFxln&title=Banana Bread
}
