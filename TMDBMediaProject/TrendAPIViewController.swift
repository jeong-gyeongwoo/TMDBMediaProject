//
//  ViewController.swift
//  TMDBMediaProject
//
//  Created by 정경우 on 2023/08/13.
//

import UIKit
import Alamofire

class TrendAPIViewController: UIViewController {
    
    
    var trendData: TrendStruct = TrendStruct(page: 1, results: [], totalPages: 1, totalResults: 1){
        didSet {
            //print("**Changed")
            movieCollectionView.reloadData()
        }
    }
    var genres: [Int:String] = [
        28 : "Action",
        12 : "Adventure",
        16 : "Animation",
        35 : "Comedy",
        80 : "Crime" ,
        99 : "Documentary",
        18 : "Drama",
        10751 : "Family",
        14 : "Fantasy",
        36 : "History",
        27 : "Horror",
        10402 : "Music",
        9648 : "Mystery",
        10749 : "Romance",
        878 : "Science Fiction",
        10770 : "TV Movie",
        53 : "Thriller",
        10752 : "War",
        37 : "Western"
    ]
    var cast: [String] = [] {
        didSet {
            //print("**Changed")
            movieCollectionView.reloadData()
        }
    }
        
    @IBOutlet var movieCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        setCollectionViewLayout()
        dispatchGroupEnterLeave()

    }
    
    func dispatchGroupEnterLeave() {
        let group = DispatchGroup()
        
        group.enter()
        trendingCallRequest() { data in
            self.trendData = data
            group.leave()
        }
        
        group.notify(queue: .main) {
           // print("END")
            self.creditCallRequest()
            self.movieCollectionView.reloadData()
        }
        
    }
       
    func trendingCallRequest(completionHandler: @escaping (TrendStruct) -> ()) {
        
        let url = "https://api.themoviedb.org/3/trending/movie/week?api_key=\(APIKey.TMDBKey)"
        AF.request(url, method: .get).validate()
            .responseDecodable(of: TrendStruct.self) { response in
                switch response.result {
                case .success(let value):
                    completionHandler(value)
                case .failure(let err):
                    print(err.localizedDescription)
                }
                
            }
        
    }
    
    func creditCallRequest() {
        for i in 0...trendData.results.count - 1 {
            let creditUrl = "https://api.themoviedb.org/3/movie/\(trendData.results[i].id)/credits?api_key=\(APIKey.TMDBKey)"
            
            AF.request(creditUrl, method: .get).validate()
                .responseDecodable(of: CreditStruct.self) { data in
                    guard let value = data.value else { return }
                    
                    for i in 0...5 {
                        self.cast.append(value.cast[i].name)
                    }
                }
            }
        }
    
}

extension TrendAPIViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendData.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendAPICollectionViewCell", for: indexPath) as! TrendAPICollectionViewCell
        
        cell.movieTitle?.text = trendData.results[indexPath.row].title
        cell.origimalTitleLable.text = trendData.results[indexPath.row].originalTitle
        cell.releaseDateLabel.text = trendData.results[indexPath.row].releaseDate
        cell.genreLabel.text = genres[trendData.results[indexPath.row].genreIDS[0]] ?? "nil값"
        cell.voteAverageLabel.text = String(trendData.results[indexPath.row].voteAverage)
        cell.releaseDateLabel.text = trendData.results[indexPath.row].releaseDate
        
        cell.borderLabel.layer.borderWidth = 1
        cell.borderLabel.layer.borderColor = UIColor(named: "black")?.cgColor
        if cast.count > 6 {
            let eachMovieCast = (cast[indexPath.row * 6 ... indexPath.row * 6 + 5]).joined(separator: ", ")
            cell.movieMember.text = "메인 출연진: \n \(eachMovieCast)"
        }
                
        let url = "https://www.themoviedb.org/t/p/w600_and_h900_bestv2\(trendData.results[indexPath.item].posterPath)"
        cell.movieImageView.kf.setImage(with: URL(string: url))

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreditAPIViewController") as! CreditAPIViewController
        
        vc.movieID = self.trendData.results[indexPath.row].id
        vc.movieTitle = self.trendData.results[indexPath.row].originalTitle
        vc.backImage = self.trendData.results[indexPath.row].backdropPath
        vc.frontImage = self.trendData.results[indexPath.row].posterPath
        vc.overview = self.trendData.results[indexPath.row].overview
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 10
        
        layout.itemSize = CGSize(width: width , height: 500)
        
        movieCollectionView.collectionViewLayout = layout
        
    }
}
