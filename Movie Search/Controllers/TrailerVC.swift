//
//  UpcomingMovieService.swift
//  Movie Search
//
//  Created by Adeel on 8/20/22.
//

import UIKit
import AVKit
import youtube_ios_player_helper
class TrailerVC: ParentViewController {

    //MARK: Outlets
      @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var btnBack: UIButton!
    //MARK: Variables
   
    var movieID = 0
    var arrVideoDetail = [VideoDataModel]()
    //MARK: VCLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerView.delegate = self
        // Do any additional setup after loading the view.
        
        getVideoDetail()
    }
    //MARK: Functions
    func getVideoDetail(){
        showLoadingView("")
        VideoDataService().getData(movieID: movieID, completion: { (response) in
            DispatchQueue.main.async {
                self.removeLoadingView()
                if let responseData = response as? [VideoDataModel]{
                    self.arrVideoDetail = responseData
                    //one piece film have no video data
                    if self.arrVideoDetail.isEmpty{
                        self.showAlertViewForPop(message: "Sorry! Trailer video is not available for this movie") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }else{
                        let index = self.arrVideoDetail.firstIndex{$0.type == "Trailer"}
                        let trailerData = self.arrVideoDetail[index!]
                        self.playerView.load(withVideoId: trailerData.key, playerVars: ["playsinline": "0"])
                    }

                }
            }
        }) { (failure) in
            DispatchQueue.main.async {
                self.removeLoadingView()
                if failure == "Unauthenticated."{
                    //Remove user default and move to login
                }
                else{
                     self.showAlertView(message: failure ?? Constants.GenericStrings.somethingWentWrong)
                }
               
            }
        }
    }
    //MARK: Button Actions
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension TrailerVC: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.playerView.playVideo()
    }
}
