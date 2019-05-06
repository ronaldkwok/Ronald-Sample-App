//
//  Movie.swift
//  Ronald Interview
//
//  Created by Ronald Kwok on 31/3/2019.
//  Copyright © 2019 Ronald Kwok. All rights reserved.
//

import Foundation

class Movie: Codable {
    // MARK: - Constant
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title = "original_title"
        case overview
    }
    
    // MARK: - Public variable
    let id: Int
    let posterPath: String?
    let title: String
    let overview: String
    
    // MARK: - Initialization
    init(id: Int, posterPath: String?, title: String, overview: String) {
        self.id = id
        self.posterPath = posterPath
        self.title = title
        self.overview = overview
    }
    
    // MARK: - Public
    func posterURL() -> URL? {
        if let urlString = posterPath {
            return URL(string: "https://image.tmdb.org/t/p/w500" + urlString)
        } else {
            return nil
        }
    }
}
