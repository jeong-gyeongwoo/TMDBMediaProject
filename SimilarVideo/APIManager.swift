//
//  APIManager.swift
//  TMDBMediaProject
//
//  Created by 정경우 on 2023/08/20.
//

import UIKit
import Alamofire

class APIManager {

    static let shared = APIManager()
    private init() { }
    
    func videoCallRequest(movieID: Int, success: @escaping (VideoStruct) -> Void ) {
        let url = "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=\(APIKey.TMDBKey)"
        AF.request(url, method: .get).validate()
            .responseDecodable(of: VideoStruct.self) { response in
                switch response.result {
                case .success(let value):
                    success(value)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    
    func similarCallRequest(movieID: Int, success: @escaping (SimilarStruct) -> Void ) {

        let url = "https://api.themoviedb.org/3/movie/\(movieID)/similar?api_key=\(APIKey.TMDBKey)"
        AF.request(url, method: .get).validate()
            .responseDecodable(of: SimilarStruct.self) { response in
                switch response.result {
                case .success(let value):
                    success(value)
                case .failure(let error):
                    print(error)
                }
                
            }
        
    }
    
 
}


