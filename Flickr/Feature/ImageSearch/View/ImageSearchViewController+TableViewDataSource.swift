//
//  ImageSearchViewController+TableViewDataSource.swift
//  Flickr
//
//  Created by Kassem Itani on 09/07/2021.
//

import UIKit
extension ImageSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistoryViewModel.history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchHistoryCellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = searchHistoryViewModel.history[indexPath.row] 
        return cell
    }
}
