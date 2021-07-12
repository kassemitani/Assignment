//
//  SearchHistoryViewModel.swift
//  Flickr
//
//  Created by Kassem Itani on 09/07/2021.
//

import UIKit

class SearchHistoryViewModel {
    var searchHistory = SearchHistoryModel()
    var history = [String]()
    var didRetreiveSearchHistory: (([String]) -> Void)?
    
    func storeSearchHistory(searchTerm:String){
        searchHistory.storeSearchHistory(searchTerm: searchTerm)
    }
  
    func retreiveSearchHistory(){
        guard let historyList = searchHistory.retreiveSearchHistory() else {return}
        self.history = historyList
        didRetreiveSearchHistory?(historyList)
    }
}
