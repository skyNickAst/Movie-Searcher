//
//  MovieTableViewCell.swift
//  Movie Searcher
//
//  Created by Nikolai Astakhov on 20.01.2023.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var movieYearLabel: UILabel!
    @IBOutlet var movieImageView: UIImageView!

    static let identifier = "MovieTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MovieTableViewCell", bundle: nil)
    }
    
    func configure(with model: Movie) {
        self.movieTitleLabel.text = model.Title
        self.movieYearLabel.text = model.Year
        let posterURL = model.Poster
        self.movieImageView.sd_setImage(with: URL(string: posterURL))
    }
}
