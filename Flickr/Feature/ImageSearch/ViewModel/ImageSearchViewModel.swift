//
//  ImageSearchViewModel.swift
//  Flickr
//
//  Created by Kassem Itani on 09/07/2021.
//

import Foundation
import UIKit
/// Error list for corresponding errors from network services in view model
enum FetchPhotoViewModelError: Error {
    //if the error comes from server
    case serverError
    // if data comes but it is corrupted
    case invalidDataError
}


class ImageSearchViewModel {
    
    var didUpdateImageSearchView: (() -> Void)?
    var didReceiveFetchPhotoError: ((FetchPhotoViewModelError) -> Void)?
    
    
    

    ///Computed property to store search results for each PhotoModel in an array
    private(set) var searchResult: [PhotoModel] = [PhotoModel]() {
        didSet {
            didUpdateImageSearchView?()
        }
    }
    
    func searchPhotos(_ searchText:String) {
        
        searchResult.removeAll()
        
        ImageSearchService.shared.fetchPhotoList(withSearchTerm: searchText) {[weak self] (photosModels, error) in
            guard let weakSelf = self else {return}
            guard let photosModel = photosModels else {return}
            
            weakSelf.searchResult.append(contentsOf: photosModel)
        }
    }
    
    
    /// fetchPhoto passes image to call back received from network service for give url. It also passes error.
    /// - Parameters:
    ///   - photoModel: PhotoModel object
    ///   - indexPath:indexpath of cell to display correct photo
    ///   - completion: callback image in case of success
    func fetchPhoto(photoModel: PhotoModel, indexPath: IndexPath , completion: @escaping (UIImage,IndexPath) -> ()){
        if let url = ImageSearchService.shared.flickrphotoURL(photo: photoModel) {
            ImageSearchService.shared.fetchPhoto(photoURL: url, indexPath: indexPath) {[weak self] (image, index, error) in
                guard let weakSelf = self else {return}
                ///Check for error in case of non pass image and corresponding index path to callback
                switch error {
                case .serverError:
                    weakSelf.didReceiveFetchPhotoError?(.serverError)
                case .invalidDataError:
                    weakSelf.didReceiveFetchPhotoError?(.invalidDataError)
                case .none:
                    /// Forced unwrapped becasue can never be nil in case of no error
                    completion(image!,index!)
                    
                }
            }
        }
    }

}
