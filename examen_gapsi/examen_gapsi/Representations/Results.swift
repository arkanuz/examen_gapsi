//
//  Results.swift
//  examen_gapsi
//
//  Created by Adolfo Lozada Serena on 24/04/21.
//

import Foundation

struct Result: Codable {
    var totalResults: Int?
    var page: Int?
    var items: [Items]?
    
    init(
        totalResults: Int? = 0,
        page: Int? = 0,
        items: [Items]? = nil) {
        self.totalResults = totalResults
        self.page = page
        self.items = items
    }
}

struct Items: Codable {
    var itemId: Int?
    var rating: String?
    var price: String?
    var image: String?
    var title: String?
    
    init(
        itemId: Int? = 0,
        rating: String = "",
        price: String = "",
        image: String = "",
        title:String = ""){
        self.itemId = itemId
        self.rating = rating
        self.price = price
        self.image = image
        self.title = title
    }
}

extension Items {
    enum CodingKeys: String, CodingKey {
        case itemId = "id"
    }
}
