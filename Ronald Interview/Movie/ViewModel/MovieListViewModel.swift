//
//  MovieListViewModel.swift
//  Ronald Interview
//
//  Created by Ronald Kwok on 31/3/2019.
//  Copyright © 2019 Ronald Kwok. All rights reserved.
//

import Foundation

protocol MovieListViewModelDelegate: class {
    func onFetchCompleted(reloadIndexPaths: [IndexPath]?)
    func onFetchFailed(reason: String)
}

class MovieListViewModel {
    
    private var movies = [Movie]()
    
    private var nextLoadingPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    weak var delegate: MovieListViewModelDelegate?
    
    public var selectedMovieIndexPath : IndexPath?
    
    var currentCount: Int {
        return movies.count
    }

    var totalCount: Int {
        return total
    }
    
    func movie(at index: Int) -> Movie {
        return movies[index]
    }
    
    func fetchMovies() {
        
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        
        NetworkingManager.getMovies(page: nextLoadingPage) { (movieResponse, error) in
            
            // error handling
            if let error = error {
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(reason: error.reason)
                    return
                }
            }
            
            // success case
            if let movieResponse = movieResponse {
                DispatchQueue.main.async {
                    
                    self.isFetchInProgress = false
                    self.movies.append(contentsOf: movieResponse.results)
                    
                    if self.nextLoadingPage > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: movieResponse.results)
                        self.delegate?.onFetchCompleted(reloadIndexPaths: indexPathsToReload)
                    }else{
                        self.total = movieResponse.totalResults
                        self.delegate?.onFetchCompleted(reloadIndexPaths: nil)
                    }
                    
                    self.nextLoadingPage += 1
                }
            }
            
        }
    }
    
    func clearMovies() {
        nextLoadingPage = 1
        movies = []
    }
    
    private func calculateIndexPathsToReload(from newMovies: [Movie]) -> [IndexPath] {
        let startIndex = movies.count - newMovies.count
        let endIndex = startIndex + newMovies.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
}

