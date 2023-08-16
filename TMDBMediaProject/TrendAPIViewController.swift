//
//  ViewController.swift
//  TMDBMediaProject
//
//  Created by 정경우 on 2023/08/13.
//

import UIKit
import Alamofire

class TrendAPIViewController: UIViewController {
    //페이지 넘어가는 데이터 처리? ->  한 페이지 마다 구조체 인스턴스??
    var value2: MovieInfo = MovieInfo(page: 1, results: [], totalPages: 1, totalResults: 1) {
        didSet {
            print("**Changed")
            movieCollectionView.reloadData()
        }
    }
    
    
    @IBOutlet var movieCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        setCollectionViewLayout()
        callRequest()

        
    }
    
    func callRequest() {
        
        let url = "https://api.themoviedb.org/3/trending/movie/week?api_key=\(APIKey.TMDBKey)"
        AF.request(url, method: .get).validate()
            .responseDecodable(of: MovieInfo.self) { response in
                guard let value = response.value else { return }
               // print(value)
               // print(value.results[0].originalTitle)
                self.value2 = value
                
                //print(self.value2.results[1].originalTitle)
            }
    }
}

extension TrendAPIViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return value2.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendAPICollectionViewCell", for: indexPath) as! TrendAPICollectionViewCell
    
        cell.movieTitle?.text = value2.results[indexPath.row].originalTitle
        cell.releaseDateLabel.text = value2.results[indexPath.row].releaseDate
        cell.genreLabel.text = "장르"
        //value2.results[indexPath.row].genreIDS // 딕셔너리?
        cell.voteAverageLabel.text = String(value2.results[indexPath.row].voteAverage)
        cell.movieMember.text = "출연진"
        cell.releaseDateLabel.text = value2.results[indexPath.row].releaseDate
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreditAPIViewController") as! CreditAPIViewController
        
        vc.value3 = value2
        vc.movieTitle = value2.results[indexPath.row].originalTitle
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 20
        let width = UIScreen.main.bounds.width - (spacing)
        
        layout.itemSize = CGSize(width: width , height: 500)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        movieCollectionView.collectionViewLayout = layout
        
        
        
    }
}






//독학 하실때 버그인지 내 실수 인지 구분하시는법?
// Modern cell configuration?
