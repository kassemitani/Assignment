//
//  SearchHistoryModel.swift
//  Flickr
//
//  Created by Kassem Itani on 09/07/2021.
//

import Foundation

class SearchHistoryModel{
    var localSearchHistory = [String]()
    let userDefault = UserDefaults.standard
    private let searchKey = "searchHistory"
    
    init() {
        if let historyData = userDefault.value(forKey: searchKey) {
            localSearchHistory.append(contentsOf: (historyData as! [String]))
        }
    }
    
    func storeSearchHistory(searchTerm:String){
        localSearchHistory.append(searchTerm)
        userDefault.setValue(localSearchHistory, forKey: searchKey)
        userDefault.synchronize()
    }
    
    func retreiveSearchHistory()->[String]?{
        guard let historyData = userDefault.value(forKey: searchKey) else {return nil}
        return (historyData as! [String])
    }
}
