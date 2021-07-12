//
//  ImageSearchViewController+CollectionViewDataSource.swift
//  Flickr
//
//  Created by Kassem Itani on 09/07/2021.
//

import UIKit

extension ImageSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (imageSearchViewModel.searchResult.count == 0) {
              self.imageSearchCollectionView.setEmptyMessage("Search for images on Flickr")
          } else {
              self.imageSearchCollectionView.restore()
          }
        return imageSearchViewModel.searchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellReuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        DispatchQueue.main.async {
            cell.imageView.image = UIImage(systemName: "photo")
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photoURL = imageSearchViewModel.searchResult[indexPath.row]
        imageSearchViewModel.fetchPhoto(photoModel: photoURL, indexPath: indexPath) { (image, index) in
            ///display image in correspodning cell with correct IndexPath
            DispatchQueue.main.async {
                if let currentCell = collectionView.cellForItem(at: index) {
                    (currentCell as? ImageCollectionViewCell)!.imageView.image = image
                }
            }
        }
    }
    

}
