//
//  ViewController.swift
//  Flickr
//
//  Created by Kassem Itani on 09/07/2021.
//

import UIKit

protocol ImageSearchVCProtocol: AnyObject {
    var onUpdateImageSeachList: (() -> Void)? { get set }
    var onRetreiveSearchHistory: (() -> Void)? { get set }
    var onSignIn: (() -> Void)? { get set }
}

class ImageSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imageSearchCollectionView: UICollectionView!
    @IBOutlet weak var searchHistoryTableView: UITableView!
    internal let photoCellReuseIdentifier = "PhotoCell"
    internal let searchHistoryCellReuseIdentifier = "SearchHistoryCell"
    
    
    var imageSearchViewModel = ImageSearchViewModel()
    var searchHistoryViewModel = SearchHistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViewModels()
        setupIdentifier()
    }
    
    func setup() {
        searchBar.delegate = self
        searchHistoryTableView.dataSource = self
        imageSearchCollectionView.dataSource = self
        imageSearchCollectionView.delegate = self
    }
    
    func setupViewModels() {
        ///Data binding for imageSearchViewModel
        imageSearchViewModel.didUpdateImageSearchView = {[weak self] in
            guard let weakself = self else {return}
            
            DispatchQueue.main.async {
                weakself.imageSearchCollectionView.reloadData()
            }
        }
        
        ///Data binding for SearchHistoryViewModel
        searchHistoryViewModel.didRetreiveSearchHistory = {[weak self] storedHistoryList in
            guard let weakself = self else {return}
            DispatchQueue.main.async {
                weakself.searchHistoryTableView.reloadData()
            }
        }
        
        ///Data binding for fetch photo errors
        imageSearchViewModel.didReceiveFetchPhotoError = {(error) in
            print(error)
        }
    }
    
    /// for UI Testing
    func setupIdentifier() {
        searchBar.accessibilityIdentifier = "searchbar"
        imageSearchCollectionView.accessibilityIdentifier = "imagecollectionview"
        searchHistoryTableView.accessibilityIdentifier = "historytableview"
    }
    
    ///To update two column layout in transition from portrait to landscape and vice versa
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageSearchCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    //MARK: - Rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        imageSearchCollectionView.reloadData()
    }

}
