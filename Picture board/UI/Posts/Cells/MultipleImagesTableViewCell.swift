//
//  MultipleImagesTableViewCell.swift
//  Picture board
//
//  Created by Eleazar Estrella on 2/15/21.
//

import UIKit
import Nuke
import RxDataSources
import RxSwift

class MultipleImagesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var mainPostImage: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var disposeBag = DisposeBag()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2
        self.profilePicture.clipsToBounds = true
        
        collectionView.register(UINib(nibName: "SingleImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SingleImageCollectionViewCell")
    }
    
    override func prepareForReuse() {
       super.prepareForReuse()
       disposeBag = DisposeBag()
    }
    
    func bind(_ item: Post) {
        email.text = item.email
        date.text = item.content.date.shortDate
        displayName.text = item.name
        Nuke.loadImage(with: ImageRequest(url: URL(string: item.profilePicture)!), into: profilePicture )
        Nuke.loadImage(with: ImageRequest(url: URL(string: item.content.pictures[0])!), into: mainPostImage )
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>( configureCell: { dataSource, collectionView, indexPath, item in
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleImageCollectionViewCell", for: indexPath) as! SingleImageCollectionViewCell
            
            Nuke.loadImage(with: ImageRequest(url: URL(string: item)!), into: cell.image)

            return cell
        })
        
        var pictures = item.content.pictures
        pictures.removeFirst()
        
        Observable.just([SectionModel(model: "default", items: pictures)])
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
