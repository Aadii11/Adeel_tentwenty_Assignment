//
//  MovieDetailVC.swift
//  Movie Search
//
//  Created by Adeel on 8/20/22.
//

import UIKit
import TagListView
import AVKit
import youtube_ios_player_helper

class MovieDetailVC: ParentViewController {

    //MARK: Outlets
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var btnGetTickets: UIButton!
    @IBOutlet weak var btnWatchTrailer: UIButton!
    @IBOutlet weak var lblGenres: UILabel!
    @IBOutlet weak var lblOverView: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var vwTaglist: TagListView!
    
 
    
    //MARK: Variables
    var movieID = 0
    var movieData = MovieDetailModel()
    //MARK: VCLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        customization()
        getMovieDetail()
    }
    //MARK: Functions
    func customization(){
        btnGetTickets.layer.cornerRadius = 15
        btnWatchTrailer.layer.cornerRadius = 15
        btnWatchTrailer.layer.borderWidth = 1
        btnWatchTrailer.layer.borderColor = UIColor(named: "lightblue")?.cgColor
    }
    func getMovieDetail(){
        showLoadingView("")
        MovieDetailService().getDetail(id: movieID, completion: { (response) in
            DispatchQueue.main.async {
                self.removeLoadingView()
                if let responseData = response as? MovieDetailModel{
                    self.movieData = responseData
                    self.setData()
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
    func setData(){
        imgPoster.setImage(with: movieData.posterPath)
        tvDescription.text = movieData.overView
        for item in movieData.geners{
            vwTaglist.addTag(item.name)
        }
        
    }

    //MARK: Button Actions
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnGetTicketAction(_ sender: Any) {
    }
    @IBAction func btnWatchTrailerAction(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "TrailerVC") as! TrailerVC
        nextVC.movieID = self.movieID
        self.navigationController?.pushViewController(nextVC, animated: true)
       
    }
    
}
