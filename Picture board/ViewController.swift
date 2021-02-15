//
//  ViewController.swift
//  Picture board
//
//  Created by Eleazar Estrella on 2/12/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwift
import Moya
import Moya_ModelMapper
import RxDataSources
import Nuke

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = PostsViewModel()
    
    let disposeBag = DisposeBag()
    
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    var refreshControl = UIRefreshControl()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Post>>(
      configureCell: { dataSource, tableView, indexPath, item in
        if item.content.pictures.count == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultPostCell", for: indexPath) as! DefaultPostTableViewCell
            cell.bind(item)
            return cell
        }else if item.content.pictures.count == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TwoImagesCell", for: indexPath) as! TwoImagesTableViewCell
            cell.bind(item)
            return cell
        }else if item.content.pictures.count == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThreeImagesCell", for: indexPath) as! ThreeImagesTableViewCell
            cell.bind(item)
            return cell
        }else if item.content.pictures.count >= 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MultipleImagesCell", for: indexPath) as! MultipleImagesTableViewCell
            cell.bind(item)
            return cell
        }
        return UITableViewCell()
    })
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: "DefaultPostCell", bundle: nil), forCellReuseIdentifier: "DefaultPostCell")
        tableView.register(UINib(nibName: "TwoImagesCell", bundle: nil), forCellReuseIdentifier: "TwoImagesCell")
        tableView.register(UINib(nibName: "ThreeImagesCell", bundle: nil), forCellReuseIdentifier: "ThreeImagesCell")
        tableView.register(UINib(nibName: "MultipleImagesCell", bundle: nil), forCellReuseIdentifier: "MultipleImagesCell")
        
        indicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubviewToFront(view)
        

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        viewModel.posts.flatMap { posts -> Observable<[SectionModel<String, Post>]> in
            return .just([SectionModel(model: "default", items: posts)])
        }.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        viewModel.isLoading
            .observeOn(MainScheduler.instance)
            .subscribe( onNext: { [weak self] isLoading in
                if isLoading {
                    self?.indicator.startAnimating()
                }else {
                    self?.indicator.stopAnimating()
                    self?.refreshControl.endRefreshing()
                }
            }).disposed(by: disposeBag)
    
    }
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel.refresh()
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = dataSource.sectionModels[indexPath.section].items[indexPath.row]
        if item.content.pictures.count == 1 {
            return 400
        }else if item.content.pictures.count == 2 {
            return 270
        }else if(item.content.pictures.count >= 3){
            return 550
        }else {
            return 400
        }
    }
}

