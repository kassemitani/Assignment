//
//  ImageSearchViewController+SearchBarDelegate.swift
//  Flickr
//
//  Created by Kassem Itani on 09/07/2021.
//

import UIKit
extension ImageSearchViewController: UISearchBarDelegate {
    
    ///show photos in collection view and hide search history and dismiss keyboard when search button is tapped
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        DispatchQueue.main.async{
            self.imageSearchCollectionView.isHidden = false
            self.searchHistoryTableView.isHidden = true
            searchBar.searchTextField.resignFirstResponder()
        }
        
        ///get search term from searhBar and store in search history and bring photo list
        if let searchTerm = searchBar.text{
            searchHistoryViewModel.storeSearchHistory(searchTerm: searchTerm)
            imageSearchViewModel.searchPhotos(searchTerm)
        }
    }
    
    ///show table view to display stored search history when search bar is tapped
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        searchHistoryViewModel.retreiveSearchHistory()
        DispatchQueue.main.async{
            self.imageSearchCollectionView.isHidden = true
            self.searchHistoryTableView.isHidden = false
        }
        
        return true
    }
    
    ///show photos list if search bar is cancelled and dismiss keyboard
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async{
            self.imageSearchCollectionView.isHidden = false
            self.searchHistoryTableView.isHidden = true
            searchBar.searchTextField.resignFirstResponder()
        }
    }
}
