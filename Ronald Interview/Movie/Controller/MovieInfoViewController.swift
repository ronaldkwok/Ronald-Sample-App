//
//  MovieInfoViewController.swift
//  Ronald Interview
//
//  Created by Ronald Kwok on 31/3/2019.
//  Copyright © 2019 Ronald Kwok. All rights reserved.
//

import UIKit

class MovieInfoViewController: UIViewController, AlertDisplayer {
    
    private var tableView: UITableView? {
        get {
            return view as? UITableView
        }
        set {
            view = newValue
        }
    }
    
    private var viewModel = MovieListViewModel()
    
    private var shouldDisplayAlert = true;
    
    // MARK: - View lifecycle
    override func loadView() {
        self.title = "Movie Info"
        tableView = UITableView()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshMovieData   ), for: .valueChanged)
        
        tableView?.refreshControl = refreshControl
        tableView?.separatorInset.left = 0
        tableView?.tableFooterView = UIView()
        tableView?.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.defaultReuseIdentifier())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    // MARKL Setup
    func setup() {
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.prefetchDataSource = self
        
        viewModel.delegate = self
        viewModel.fetchMovies()
    }
    
    @objc private func refreshMovieData(_ sender: Any) {
        // Fetch Weather Data
        viewModel.clearMovies()
        
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
        
        viewModel.fetchMovies()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MovieInfoViewController: MovieListViewModelDelegate {
    func onFetchCompleted(reloadIndexPaths: [IndexPath]?) {
        
        shouldDisplayAlert = true;
        
        guard let reloadIndexPaths = reloadIndexPaths else {
            tableView?.refreshControl?.endRefreshing()
            tableView?.reloadData()
            return
        }
        
        let visibleReloadIndexPaths = Set(tableView?.indexPathsForVisibleRows ?? []).intersection(reloadIndexPaths)
        
        if(visibleReloadIndexPaths.count > 0){
            tableView?.reloadRows(at: Array(visibleReloadIndexPaths), with: .none)
        }

    }
    
    func onFetchFailed(reason: String) {
        
        tableView?.refreshControl?.endRefreshing()
        
        if (shouldDisplayAlert) {
            let title = "Warning"
            let action = UIAlertAction(title: "OK", style: .default)
            displayAlert(with: title , message: reason, actions: [action])
            shouldDisplayAlert = false;
        }
    }
}

extension MovieInfoViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.defaultReuseIdentifier(), for: indexPath) as! MovieTableViewCell
        
        if(indexPath.row < viewModel.currentCount){
            cell.model = viewModel.movie(at: indexPath.row)
        }else{
            cell.model = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if viewModel.selectedMovieIndexPath == indexPath {
            return UITableView.automaticDimension
        }
        
        return MovieTableViewCell.normalHeight()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var reloadIndexPaths = [indexPath]
        
        if indexPath != viewModel.selectedMovieIndexPath {
        
            if let beforeSelectedPath = viewModel.selectedMovieIndexPath,
                let visablePaths = tableView.indexPathsForVisibleRows,
                visablePaths.contains(beforeSelectedPath) {
                reloadIndexPaths.append(beforeSelectedPath)
            }
            
            viewModel.selectedMovieIndexPath = indexPath
            
        }else{
            viewModel.selectedMovieIndexPath = nil
        }
        
        DispatchQueue.main.async {
            tableView.reloadRows(at: reloadIndexPaths, with: .automatic)
        }
        
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let firstIndexPath = indexPaths.first else {
            return
        }
        
        if(firstIndexPath.row > viewModel.currentCount){
            viewModel.fetchMovies()
        }
    }
}
