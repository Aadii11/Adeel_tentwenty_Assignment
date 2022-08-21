//
//  SearchMovieVC.swift
//  Movie Search
//
//  Created by Adeel on 8/20/22.
//

import UIKit

class SearchMovieVC: ParentViewController {

    //MARK: Outlets
    @IBOutlet weak var vwTop: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tblMovies: UITableView!
    @IBOutlet weak var lblNoRecord: UILabel!
    
    //MARK: Variables
    var movieData = MoviesModel()
    var arrSearchMovies = [UpcomimgMoviesModel]()
    var page = 1

    //MARK: VCLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        customization()
    }
    //MARK: Functions
    func customization(){
        vwTop.layer.cornerRadius = 25
    }
    func searchMovie(){
        page == 1 ? showLoadingView("") : print("Don't show loader")
        MoviesListService().getData(page: page,isFromSearch: true,query: txtSearch.text!, completion: { (response) in
            DispatchQueue.main.async {
                self.removeLoadingView()
                if let responseData = response as? MoviesModel{
                    self.movieData = responseData
                    self.arrSearchMovies.append(contentsOf: self.movieData.upComingMoviesData)
                    self.tblMovies.reloadData()
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
    @IBAction func btnSearchAction(_ sender: Any) {
        if txtSearch.text != ""{
            arrSearchMovies.removeAll()
            searchMovie()
        }else{
            showAlertView(message: "Please enter movie name to search.")
        }
       
    }
}
//MARK: Tableview Delegate & DataSource
extension SearchMovieVC :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrSearchMovies.count == 0{
            lblNoRecord.alpha = 1
            tblMovies.alpha = 0
        }else{
            lblNoRecord.alpha = 0
            tblMovies.alpha = 1
        }
        return arrSearchMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTCell") as! SearchTCell
        cell.imgPoster.setImage(with: arrSearchMovies[indexPath.row].backdropPath)
        cell.lblName.text = arrSearchMovies[indexPath.row].orignalTitle
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        nextVC.movieID = arrSearchMovies[indexPath.row].id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == (arrSearchMovies.count - 1)
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

                self.tblMovies.tableFooterView = spinner
                self.tblMovies.tableFooterView?.isHidden = false
                
                page += 1
                searchMovie()
            }

           
        }
    }
}
