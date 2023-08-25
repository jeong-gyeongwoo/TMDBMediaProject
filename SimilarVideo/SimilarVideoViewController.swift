//
//  SimilarVideoViewController.swift
//  TMDBMediaProject
//
//  Created by 정경우 on 2023/08/20.
//

import UIKit
//import Alamofire

class SimilarVideoViewController: UIViewController {

    @IBOutlet var videoView: UIView!
    @IBOutlet var similarView: UIView!
    
    var videoList: VideoInfo = VideoInfo(id: 1, results: [])
    var similarList: SimilarInfo = SimilarInfo(page: 1, results: [], totalPages: 1, totalResults: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // dispatchGroupNotify() //에러
    }
    
    func dispatchGroupNotify() {
       
        let group = DispatchGroup()
        
        DispatchQueue.global().async(group: group) {
            APIManager.shared.videoCallRequest(movieID: 976573) { data in
                self.videoList = data
                print("1111111111111111")
            }
        }
        DispatchQueue.global().async(group: group) {
            APIManager.shared.similarCallRequest(movieID: 976573) { data in
                self.similarList = data
                print("2222222222222222")
            }
        }
       
        group.notify(queue: .main) {
            //print("END")
        }
    }

    @IBAction func segmentedControlClicked(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            videoView.alpha = 1
            similarView.alpha = 0
            
            
            
        } else {
            videoView.alpha = 0
            similarView.alpha = 1
        }
        
    }
    

}

//과제: TMDB video, similar API 호출,dispatchgroup + 세그먼트 선택하면 데이터가 갱신
//에러
//1. dispatchGroupNotify() 통신에러
//2. 세그먼트 씬 command + n  view, viewController 연결 후 에러
// 세그먼트 씬 텍스트 바꾸는법?


//보통 하나의 화면에서 하나의 뷰컨트롤러가 관리한다?
//register
//뷰컨트롤러 위에 삭제하니까 에러 사라짐
