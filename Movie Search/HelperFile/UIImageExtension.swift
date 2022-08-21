//
//  UpcomingMovieService.swift
//  Movie Search
//
//  Created by Adeel on 8/20/22.
//

import UIKit
import Foundation
import Kingfisher
extension UIImageView {
    func setImage(with urlString: String){
        guard let url = URL.init(string: urlString) else {
            return
        }
        let resource = ImageResource(downloadURL: url, cacheKey: urlString)
        var kf = self.kf
        kf.indicatorType = .activity
        self.kf.setImage(with: resource)
    }
}
