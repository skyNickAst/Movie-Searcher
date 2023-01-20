//
//  ViewController.swift
//  Movie Searcher
//
//  Created by Nikolai Astakhov on 20.01.2023.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, NetworkingMovieDelegate {

    @IBOutlet var movieTableView: UITableView!
    @IBOutlet var searchField: UITextField!
    @IBOutlet var startImage: UIImageView!
    
    var networking = Networking()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        movieTableView.delegate = self
        movieTableView.dataSource = self
        searchField.delegate = self
        networking.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchingMovie = searchField.text, !searchingMovie.isEmpty {
            searchField.resignFirstResponder()
            self.networking.searchMovie(named: searchingMovie)
            startImage.alpha = 0
            searchField.text = ""
            return true
        } else {
            return false
        }
    }
    
    //MARK: - Networking Movie Delegate
    
    func reloadMoviesOnTable() {
        DispatchQueue.main.async {
            self.searchField.placeholder = "Search..."
            self.movieTableView.reloadData()
            let indexPath = IndexPath(row: 0 , section: 0)
            self.movieTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func failedWithError() {
        DispatchQueue.main.async {
            self.searchField.placeholder = "No such movie has been found!"
        }
    }
    
    //MARK: - Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networking.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        movieTableView.allowsSelection = true
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.configure(with: networking.movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = "https://www.imdb.com/title/\(networking.movies[indexPath.row].imdbID)"
        let vc = SFSafariViewController(url: URL(string: url)!)
        present(vc, animated: true)
    }
}
