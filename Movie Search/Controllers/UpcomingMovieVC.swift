//
//  UpcomingMovieVC.swift
//  Movie Search
//
//  Created by Adeel on 8/20/22.
//

import UIKit
import Kingfisher
class UpcomingMovieVC: ParentViewController {
    //MARK: Outlets
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var tblMovieList: UITableView!
    @IBOutlet weak var btnSearch: UIButton!
    
    //MARK: Variables
    var movieData = MoviesModel()
    var arrUpcomingMovies = [UpcomimgMoviesModel]()
    var page = 1
    //MARK: VCLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovieList()
    }
    //MARK: Functions
    func getMovieList(){
        page == 1 ? showLoadingView("") : print("Don't show loader")
        MoviesListService().getData(page: page, completion: { (response) in
            DispatchQueue.main.async {
                self.removeLoadingView()
                if let responseData = response as? MoviesModel{
                    self.movieData = responseData
                    self.arrUpcomingMovies.append(contentsOf: self.movieData.upComingMoviesData)
                    self.tblMovieList.reloadData()
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
    @IBAction func btnSearchAction(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchMovieVC") as! SearchMovieVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

//MARK: Tableview Delegate & DataSource
extension UpcomingMovieVC :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUpcomingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTCell") as! MoviesTCell
        cell.imgPoster.setImage(with: arrUpcomingMovies[indexPath.row].backdropPath)
        cell.lblMovieName.text = arrUpcomingMovies[indexPath.row].orignalTitle
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        nextVC.movieID = arrUpcomingMovies[indexPath.row].id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == (arrUpcomingMovies.count - 1)
        {
            if  page < movieData.totalpage {
                var spinner:UIActivityIndicatorView!
                if #available(iOS 13.0, *) {
                     spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
                } else {
                     spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
                }
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

                self.tblMovieList.tableFooterView = spinner
                self.tblMovieList.tableFooterView?.isHidden = false
                
                page += 1
                getMovieList()
            }

           
        }
    }
}
