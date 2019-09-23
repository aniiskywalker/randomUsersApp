//
//  UsersTableViewCell.swift
//  RandomUsersApp
//
//  Created by Ana Victoria Frias on 9/22/19.
//  Copyright © 2019 Ana Victoria Frias. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    @IBOutlet weak var likeIcon: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var imageUserView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageUserView.layer.cornerRadius = imageUserView.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
