//
//  Networking.swift
//  Movie Searcher
//
//  Created by Nikolai Astakhov on 20.01.2023.
//

import Foundation

protocol NetworkingMovieDelegate {
    func reloadMoviesOnTable()
    func failedWithError()
}

class Networking {
    
    var delegate: NetworkingMovieDelegate?
    var movies = [Movie]()
    let defaultUrl = URL(string: "https://www.omdbapi.com/?apikey=3aea79ac&s=king&type=movie")
    
    func searchMovie(named movieName: String) {
        let movieNameForNet = movieName.replacingOccurrences(of: " ", with: "%20")
        
        URLSession.shared.dataTask(with: (URL(string: "https://www.omdbapi.com/?apikey=3aea79ac&s=\(movieNameForNet)&type=movie") ?? defaultUrl)!,completionHandler: { data, response, error in
            guard let data = data, error == nil else { return }
            // Convert
            var result: MovieResult?
            do {
                result = try JSONDecoder().decode(MovieResult.self, from: data)
            } catch {
                print("Error in convertation")
            }
            // Update movies array
            if let finalResult = result {
                self.movies.removeAll()
                let newMovie = finalResult.Search
                self.movies.append(contentsOf: newMovie)
                self.delegate?.reloadMoviesOnTable()
            } else {
                print("Search error, data was not updated!")
                self.delegate?.failedWithError()
            }
        }).resume()
    }
}
