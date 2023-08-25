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
    
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var frontImageView: UIImageView!
    @IBOutlet var backImageView: UIImageView!
    @IBOutlet var creditAPITableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callRequest(movieID: movieID)
        //찾아보기
        //creditAPITableView.rowHeight = UITableView.automaticDimension
        creditAPITableView.rowHeight = 120
        creditAPITableView.delegate = self
        creditAPITableView.dataSource = self
        navigationController?.navigationBar.topItem?.title = ""
        title = "출연/제작"
        
        // print(movieCast,"111111111111111111")
    }
    
    func callRequest(movieID: Int) {

        let url = "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=\(APIKey.TMDBKey)"
        
        AF.request(url, method: .get).validate()
            .responseDecodable(of: CreditStruct.self) { data in
                switch data.result {
                case .success(let value):
                    for i in 0...4 {
                        self.movieCast.append(value.cast[i].name)
                        self.castRole.append(value.cast[i].character!)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 셀 2개의 갯수
       // print(movieCast.count)
        return  movieCast.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let castCell = tableView.dequeueReusableCell(withIdentifier: "CastTableViewCell") as? CastTableViewCell else { return UITableViewCell() }
        //        guard let overViewCell = tableView.dequeueReusableCell(withIdentifier: "OverViewTableViewCell") as? OverViewTableViewCell else { return UITableViewCell() }
        
        
        let url = "https://www.themoviedb.org/t/p/w600_and_h900_bestv2\(creditData.cast[indexPath.row].profilePath!)"
        castCell.castImageView.kf.setImage(with: URL(string: url))
        
        castCell.castNameLabel.text = movieCast[indexPath.row]
        castCell.castRoleLabel.text = castRole[indexPath.row]
        
        return castCell
    }
}


// 글씨 안 잘리게 레이아웃 변경하기
// 셀 2개로 추가
//tableView.reloadRows(at: [indexPath], with: .fade)


// print(movieCast.count) 왜 3번 찍히는지
// 캐릭터만 왜 닐값?
