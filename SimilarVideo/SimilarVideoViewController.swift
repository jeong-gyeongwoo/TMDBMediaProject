//
//  SimilarVideoViewController.swift
//  TMDBMediaProject
//
//  Created by 정경우 on 2023/08/20.
//

import UIKit
import Alamofire
import SnapKit

class SimilarVideoViewController: UIViewController {
    
    @IBOutlet var videoView: UIView!
    @IBOutlet var similarView: UIView!
    
    var similarList: SimilarStruct = SimilarStruct(page: 0, results: [], totalPages: 0, totalResults: 0)
    
    var videoList: VideoStruct = VideoStruct(id: 0, results: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatchGroupNotify()
        videoView.alpha = 1
        similarView.alpha = 0
    }
    
    func dispatchGroupNotify() {
        
        let group = DispatchGroup()
        
            group.enter()
            APIManager.shared.videoCallRequest(movieID: 976573) { data in
                self.videoList = data
               // print("1111111111111111")
                group.leave()
            }
        
            group.enter()
            APIManager.shared.similarCallRequest(movieID: 976573) { data in
                self.similarList = data
               // print("2222222222222222")
                group.leave()
            }
        
        
        group.notify(queue: .main) {
            // print("END")
            //print(self.videoList2)
            self.setText()
        }
    }
    
    func setText() {
        
        let similarText = UITextView()
        similarView.addSubview(similarText)
        similarText.text = "\(similarList)"
        similarText.snp.makeConstraints { make in
            make.size.equalTo(300)
            make.center.equalTo(view)
        }
        let videoText = UITextView()
            videoView.addSubview(videoText)
            videoText.text = "\(videoList)"
            videoText.snp.makeConstraints { make in
                make.size.equalTo(300)
                make.center.equalTo(view)
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




