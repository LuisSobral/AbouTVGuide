//
//  TableViewCell.swift
//  AbouTVGuide
//
//  Created by Luis Felipe Sobral on 20/06/17.
//  Copyright © 2017 AbouTV. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imagemSerie: UIImageView!
    
    @IBOutlet weak var nomeSerie: UILabel!
    
    @IBOutlet weak var ratingSerie: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
