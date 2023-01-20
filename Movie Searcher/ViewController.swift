//
//  ViewController.swift
//  Movie Searcher
//
//  Created by Nikolai Astakhov on 20.01.2023.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    @IBOutlet var field: UITextField!
    @IBOutlet var startImage: UIImageView!
    
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        field.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovie()
        startImage.alpha = 0
        field.text = ""
        return true
    }
    
    func searchMovie() {
        field.resignFirstResponder()
        guard let text = field.text, !text.isEmpty else { return }
        movies.removeAll()
        let query = text.replacingOccurrences(of: " ", with: "%20")
        URLSession.shared.dataTask(with: URL(string: "https://www.omdbapi.com/?apikey=3aea79ac&s=\(query)&type=movie")!,completionHandler: { data, response, error in
            guard let data = data, error == nil else { return }
            // Convert
            var result: MovieResult?
            do {
                result = try JSONDecoder().decode(MovieResult.self, from: data)
            } catch {
                print("Error in convertation")
            }
            guard let finalResult = result else { return }
            // Update our movies array
            let newMovie = finalResult.Search
            self.movies.append(contentsOf: newMovie)
            // Resfresh our table
            DispatchQueue.main.async {
                self.table.reloadData()
                let indexPath = IndexPath(row: 0 , section: 0)
                self.table.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            
            
        }).resume()
    }
    
    //MARK: - Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = "https://www.imdb.com/title/\(movies[indexPath.row].imdbID)"
        let vc = SFSafariViewController(url: URL(string: url)!)
        present(vc, animated: true)
    }
}

//MARK: - Structures

struct MovieResult: Codable {
    let Search: [Movie]
}

struct Movie: Codable {
    let Title: String
    let Year: String
    let imdbID: String
    let _Type: String
    let Poster: String
    
    private enum CodingKeys: String, CodingKey {
        case Title, Year, imdbID, _Type = "Type", Poster
    }
}
