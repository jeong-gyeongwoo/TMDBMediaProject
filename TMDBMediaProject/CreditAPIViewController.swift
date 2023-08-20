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
    var overview = ""
    var creditData: CreditStruct = CreditStruct(id: 1, cast: [], crew: [])
    
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var frontImageView: UIImageView!
    @IBOutlet var backImageView: UIImageView!
    @IBOutlet var creditAPITableView: UITableView!
    @IBOutlet var overviewTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creditAPITableView.delegate = self
        creditAPITableView.dataSource = self
        callRequest()
        navigationController?.navigationBar.topItem?.title = ""
        title = "출연/제작"
        overviewTextView.text = overview
        //print(movieCast)
    }
    
    func extendTextField() {
        
    }
      
    func callRequest() {
        
        let url = "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=\(APIKey.TMDBKey)"
        AF.request(url, method: .get).validate()
            .responseDecodable(of: CreditStruct.self) { data in
                guard let value = data.value else { return }
                self.movieCast.removeAll()
                for i in 0...5 {
                    self.movieCast.append(value.cast[i].name)
                }
                self.creditData = value
            }
        
        let frontUrl = "https://www.themoviedb.org/t/p/w600_and_h900_bestv2\(frontImage)"
        frontImageView.kf.setImage(with: URL(string: frontUrl))
        
        let backUrl = "https://www.themoviedb.org/t/p/w600_and_h900_bestv2\(backImage)"
        backImageView.kf.setImage(with: URL(string: backUrl))
        movieTitleLabel.text = "\(movieTitle)"
    }
    
}

extension CreditAPIViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movieCast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let castCell = tableView.dequeueReusableCell(withIdentifier: "CastTableViewCell") as? CastTableViewCell else { return UITableViewCell() }
        
        let url = "https://www.themoviedb.org/t/p/w600_and_h900_bestv2\(creditData.cast[indexPath.row].profilePath)"
        castCell.castImageView.kf.setImage(with: URL(string: url))
        castCell.castNameLabel.text = creditData.cast[indexPath.row].name
        castCell.castRoleLabel.text = creditData.cast[indexPath.row].character
 
        return castCell
    }
}


//셀이 안나옴

//텍스트 필드 펼치기 기능  labelline 0 -> 4
//1. 하나의 테이블뷰에 2개 셀
// -> cellForRowAt에서 섹션마다 셀을 다르게 넣어주는걸 모르겠음
// https://rldd.tistory.com/493
//2. 테이블뷰-셀 2개
// -> 테이뷸뷰 2개를 어떻게 인식??
//3. UIview로 -> line이 없음

