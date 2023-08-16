//
//  ViewController.swift
//  TMDBMediaProject
//
//  Created by 정경우 on 2023/08/13.
//

import UIKit

class CreditAPIViewController: UIViewController {
    var movieTitle = ""
    var value3: MovieInfo = MovieInfo(page: 1, results: [], totalPages: 1, totalResults: 1)
    
    @IBOutlet var movieTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieTitleLabel.text = movieTitle
        
        
    }
    


}

// cast
