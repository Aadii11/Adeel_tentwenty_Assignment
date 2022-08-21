//
//  SearchTCell.swift
//  Movie Search
//
//  Created by Adeel on 8/20/22.
//

import UIKit

class SearchTCell: UITableViewCell {
    
    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgPoster.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
