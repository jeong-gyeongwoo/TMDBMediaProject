//
//  ViewController.swift
//  TMDBMediaProject
//
//  Created by 정경우 on 2023/08/13.
//

import UIKit
import Alamofire
import Kingfisher

class CreditAPIViewController: UIViewController {
    var movieID: Int = 1
    var movieTitle: String = ""
    var backImage = ""
    var frontImage = ""
    var movieCast:[String] = []
    var castRole:[String] = []
    var overview = ""
    var creditData: CreditStruct = CreditStruct(id: 1, cast: [], crew: [])
    var isExpand = false
    
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var frontImageView: UIImageView!
    @IBOutlet var backImageView: UIImageView!
    @IBOutlet var creditAPITableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callRequest(movieID: movieID)
        creditAPITableView.rowHeight = UITableView.automaticDimension
        creditAPITableView.estimatedRowHeight = 200
        //creditAPITableView.rowHeight = 200
        creditAPITableView.delegate = self
        creditAPITableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.title = ""
        title = "출연/제작"
        
    }
    
    func callRequest(movieID: Int) {

        let url = "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=\(APIKey.TMDBKey)"
        
        AF.request(url, method: .get).validate()
            .responseDecodable(of: CreditStruct.self) { data in
                switch data.result {
                case .success(let value):
                    for i in 0...5 {
                        self.movieCast.append(value.cast[i].name)
                        self.castRole.append(value.cast[i].character ?? "none")
                    }
                    self.creditData = value
                    self.creditAPITableView.reloadData()
                case .failure(let value):
                    print(value.localizedDescription)
                }
                
                let frontUrl = "https://www.themoviedb.org/t/p/w600_and_h900_bestv2\(self.frontImage)"
                self.frontImageView.kf.setImage(with: URL(string: frontUrl))
                
                let backUrl = "https://www.themoviedb.org/t/p/w600_and_h900_bestv2\(self.backImage)"
                self.backImageView.kf.setImage(with: URL(string: backUrl))
                self.movieTitleLabel.text = "\(self.movieTitle)"

            }
    }
}

extension CreditAPIViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return  movieCast.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let overViewCell = tableView.dequeueReusableCell(withIdentifier: "OverViewTableViewCell") as? OverViewTableViewCell else { return UITableViewCell() }
            overViewCell.overviewLabel.text = overview
            overViewCell.overviewLabel.numberOfLines = isExpand ? 0 : 3

            return overViewCell
            
        } else if indexPath.section == 1 {
            guard let castCell = tableView.dequeueReusableCell(withIdentifier: "CastTableViewCell") as? CastTableViewCell else { return UITableViewCell() }
            
            let url = "https://www.themoviedb.org/t/p/w600_and_h900_bestv2\(creditData.cast[indexPath.row].profilePath!)"
            castCell.castImageView.kf.setImage(with: URL(string: url))
            castCell.castNameLabel.text = movieCast[indexPath.row]
            castCell.castRoleLabel.text = castRole[indexPath.row]
            
            return castCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isExpand.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Overview"
        } else {
            return  "Cast"
        }
    }
    
}

