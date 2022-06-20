//
//  FavoriteVC.swift
//  Movie Lib
//
//  Created by Ananthamoorthy Haniman on 2022-05-22.
//

import UIKit
import RxCocoa
import RxSwift


class FavoriteVC: UIViewController {
    
    private let favoriteTableView:UITableView = {
        let ftv = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        return ftv
    }()
    
    private let errorView:ErrorView = ErrorView()
    private let loaderView:LoaderView = LoaderView()
    
    let disposeBag = DisposeBag()
    
    private let viewModel:FavoriteViewModel = FavoriteViewModel(
        favoriteService: FavoriteLocalService()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constant.backgroundColor
        setupUI()
        setupBindings()
        
    }
    
    // MARK: - Handle & Receive Observable events
    private func setupBindings(){
        
        favoriteTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel // receive favorite movies datas
            .movies
            .observe(on: MainScheduler.instance)
            .bind(to: favoriteTableView.rx.items(cellIdentifier: FavoriteCellView.indentifier, cellType: FavoriteCellView.self)){ row,data, cell in
                cell.config(movie: data)
                self.showThisView(view: self.favoriteTableView)
            }.disposed(by: disposeBag)
        
        viewModel
            .error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext:{ error in
                self.errorView.config(error: error)
                self.showThisView(view: self.errorView)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext:{ status in
                if status {
                    self.showThisView(view: self.loaderView)
                }else{
                    self.loaderView.alpha = 0
                }
            })
            .disposed(by: disposeBag)
        
        favoriteTableView // observe when table item was deleted
            .rx
            .itemDeleted
            .subscribe(onNext:{ indexPath in
                let cell = self.favoriteTableView.cellForRow(at: indexPath) as! FavoriteCellView
                self.viewModel.deleteFavorite(trackerId: cell.movie!.trackId,at: indexPath)
            }).disposed(by: disposeBag)
        
        favoriteTableView // observe when table item was selected
            .rx
            .modelSelected(MovieEntity.self)
            .subscribe(onNext: { [weak self] (model) in
                let movie:Movie = Movie(trackId: model.trackId, trackName: model.trackName, primaryGenreName: model.primaryGenreName, currency: model.primaryGenreName, longDescription: model.longDescription, trackPrice: model.trackPrice, trackViewUrl: model.trackViewUrl, artworkUrl100: model.artworkUrl100, isFavorite: model.isFavorite)
                let movieDetailVC = MovieDetailVC()
                movieDetailVC.config(movie: movie)
                self?.navigationController?.pushViewController(movieDetailVC, animated: true)
                
            }).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.getFavorites()
    }
    
    // MARK: - Declare & Add Subviews
    private func setupUI(){
        favoriteTableView.frame = self.view.frame
        favoriteTableView.register(FavoriteCellView.self, forCellReuseIdentifier: FavoriteCellView.indentifier)
        
        errorView.frame = self.view.frame
        loaderView.frame = self.view.frame
        
        self.view.addSubview(favoriteTableView)
        self.view.addSubview(errorView)
        self.view.addSubview(loaderView)
        
        self.showThisView(view: self.favoriteTableView)
        
    }
    
    // MARK: - Show single UI view
    private func showThisView(view:UIView){
        self.errorView.alpha = 0
        self.loaderView.alpha = 0
        self.favoriteTableView.alpha = 0
        
        view.alpha = 1
    }
    
    
}

extension FavoriteVC:UITableViewDelegate{
    
    // MARK: - Define table item row size
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
}
