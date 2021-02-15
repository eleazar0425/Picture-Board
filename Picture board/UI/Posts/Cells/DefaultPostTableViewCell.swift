//
//  DefaultPostTableViewCell.swift
//  Picture board
//
//  Created by Eleazar Estrella on 2/15/21.
//

import UIKit
import Nuke

class DefaultPostTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var mainPostImage: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var date: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2
        self.profilePicture.clipsToBounds = true
    }
    
    func bind(_ item: Post){
        email.text = item.email
        date.text = item.content.date.shortDate
        displayName.text = item.name
        Nuke.loadImage(with: ImageRequest(url: URL(string: item.profilePicture)!), into: profilePicture )
        Nuke.loadImage(with: ImageRequest(url: URL(string: item.content.pictures[0])!), into: mainPostImage )
    }

}
