//
//  MovieVC.swift
//  Movie Lib
//
//  Created by Ananthamoorthy Haniman on 2022-05-22.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
class MovieVC: UIViewController{
    
    let searchBar:UISearchBar = UISearchBar()
    var collectionView:UICollectionView?
    
    let viewModel:MovieViewModel = MovieViewModel(
        movieService: MovieRemoteService()
    )
    
    let disposeBag = DisposeBag()
    
    var errorView:ErrorView?
    var emptySearchView:EmptySearchView?
    var loaderView:LoaderView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        setupUI()
        hideKeyboardWhenTappedAround()
        setupBindings()
    }
    
    // MARK: - Handle & Receive Observable events
    private func setupBindings(){
        
        viewModel.movies // subscribe and receive movie datas
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView!.rx.items(cellIdentifier: MovieCellView.indentifier, cellType: MovieCellView.self)){ row,data, cell in
                cell.config(data: data)
                self.showThisView(view: self.collectionView!)
            }
            .disposed(by: disposeBag)
        
        viewModel.isLoading // receive when loading event emits
            .observe(on: MainScheduler.instance)
            .subscribe(onNext:{ status in
                if status {
                    self.showThisView(view: self.loaderView!)
                }else{
                    self.loaderView!.alpha = 0
                }
                
            })
            .disposed(by: disposeBag)
        
        viewModel.error // receive when error event emits
            .observe(on: MainScheduler.instance)
            .subscribe(onNext:{ error in
                self.errorView?.config(error: error)
                self.showThisView(view: self.errorView!)
            })
            .disposed(by: disposeBag)
        
        // handle collection view model item selection
        collectionView?
            .rx
            .modelSelected(Movie.self)
            .subscribe(onNext: { (model) in
                // navigate to details view
                let movieDetailVC = MovieDetailVC()
                movieDetailVC.delegate = self
                movieDetailVC.config(movie: model)
                self.navigationController?.pushViewController(movieDetailVC, animated: true)
                
            }).disposed(by: disposeBag)
        
    }
    
    // MARK: - Declare & Add Subviews
    private func setupUI(){
        // declare collection view layout type and config sizes of layout items.
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionViewLayout.itemSize = CGSize(width: view.frame.size.width / 2.4, height: 300)
        
        self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout)
        self.collectionView?.register(MovieCellView.self, forCellWithReuseIdentifier: MovieCellView.indentifier)
        self.collectionView?.keyboardDismissMode = .onDrag
        self.collectionView?.backgroundColor = Constant.backgroundColor
        self.view.addSubview(collectionView!)
        
        self.loaderView = LoaderView(frame: view.frame)
        self.errorView = ErrorView(frame: view.frame)
        self.emptySearchView = EmptySearchView(frame: view.frame)
        
        view.addSubview(loaderView!)
        view.addSubview(errorView!)
        view.addSubview(emptySearchView!)
        
        showThisView(view: self.emptySearchView!)
        
    }
    
    //MARK: - Setup Search bar & Controller
    private func setupVC(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Stranger things"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationItem.title = ""
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
        navigationItem.titleView = searchBar
        tabBarController?.tabBar.backgroundColor = Constant.backgroundColor
    }
    
    
    // MARK: - Show single UI view
    private func showThisView(view:UIView){
        // This function implemented for show a single view based on requirement
        self.errorView!.alpha = 0
        self.loaderView!.alpha = 0
        self.collectionView!.alpha = 0
        self.emptySearchView!.alpha = 0
        
        view.alpha = 1
    }
    
    
}



extension MovieVC:UISearchBarDelegate, MovieDelegate{
    
    // MARK: - This method from MovieDelegate, it will call when tapped add to favorite button from Movie Details view.
    func update() {
        collectionView?.reloadData()
    }
    
    // MARK: - Call search function when user tap search button from keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchValue = searchBar.text {
            viewModel.search(for: searchValue)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let searchValue = searchBar.text {
            if searchValue.isEmpty {
                showThisView(view: self.emptySearchView!)
            }
        }
    }
    
    /// `hideKeyboardWhenTappedAround` - source https://stackoverflow.com/questions/52019014/make-keyboard-disappear-when-clicking-outside-of-search-bar-swift
    //  this function added for dismiss keyboard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        searchBar.endEditing(true)
    }
    
}
