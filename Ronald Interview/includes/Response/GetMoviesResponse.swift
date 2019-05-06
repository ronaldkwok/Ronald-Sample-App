//
//  GetMoviesResponse.swift
//  Ronald Interview
//
//  Created by Ronald Kwok on 31/3/2019.
//  Copyright © 2019 Ronald Kwok. All rights reserved.
//

import Foundation

class GetMoviesResponse: Codable {
    // MARK: - Constant
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
    
    // MARK: - Public variable
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [Movie]
    
    // MARK: - Initialization
    init(page: Int, totalResults: Int, totalPages: Int, results: [Movie]) {
        self.page = page
        self.totalResults = totalResults
        self.totalPages = totalPages
        self.results = results
    }
}
