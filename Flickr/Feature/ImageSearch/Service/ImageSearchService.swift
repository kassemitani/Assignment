//
//  ImageSearchService.swift
//  Flickr
//
//  Created by Kassem Itani on 09/07/2021.
//

import Foundation
import UIKit


enum FetchPhotoModelError: Error {
    //if the error comes from server
    case serverError
    // if data comes but it is corrupted
    case invalidDataError
    //no error found
    case none
}


class ImageSearchService {
    
    private let session = URLSession.shared
    
    /// stores cached images against image url as key
    private let cachedImages = NSCache<NSURL, UIImage>()
    
    static let shared: ImageSearchService = {
        let instance = ImageSearchService()
        return instance
    }()
    
    /// fetchPhotoList brings list of photos using flickerPhotosSearchAPI given in FlickrAPI.swift
    /// - Parameters:
    ///   - searchTerm: specific term to search
    ///   - completion: Callback for PhotoModel and can also takes error that is not handled yet.
    func fetchPhotoList(withSearchTerm searchTerm: String, completion: @escaping ([PhotoModel]?, Error?) -> ()){
        
        ///get search API with given search term
        guard let flickrURL =  flickrPhotosSearchURL(searchTerm: searchTerm) else {
            return
        }
        
        let request = URLRequest(url: flickrURL)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            //decode json data and pass PhotoModel array to callBack
            DispatchQueue.main.async {
                guard let data = data,
                      let photosListData = try? JSONDecoder().decode(PhotoSearchResponse.self, from: data) else {
                    completion(nil,nil)//handle error approprietly
                    return
                }
                completion(photosListData.photos.photo,nil)
            }
        }
        task.resume()
        
    }
    
    /// Return cached images for url key
    /// - Parameter url: url key for which images are stored in cache
    /// - Returns: cached image if available
    func image(url: URL) -> UIImage? {
        return cachedImages.object(forKey: url as NSURL)
    }
    
    
    public func flickrphotoURL(photo:PhotoModel)->URL?{
        let urlAPI = "https://farm\(photo.farm).static.flickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
        guard let flickrURL = URL(string: urlAPI) else {
            return nil
        }
        return flickrURL
    }

    
    /// fetchPhoto brings an image from given url. it first checks if image is available in cached images if not it downloads from server and stores in cached images as well as passes to callback.
    /// - Parameters:
    ///   - photoURL: url of photo
    ///   - indexPath: indexpath of cell to display correct photo
    ///   - completion: callback for error in case of failure or image in case of success
    func fetchPhoto(photoURL: URL, indexPath: IndexPath , completion: @escaping (UIImage?,IndexPath?,FetchPhotoModelError) -> ()){
        
        
        /// check if image is available for given url in cached images
        if let cachedImage = image(url: photoURL) {
            DispatchQueue.main.async {
                completion(cachedImage, indexPath, .none)
            }
            return
        }
        
        let request = URLRequest(url: photoURL)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                //check for error returned by server
                if (error != nil) {
                    completion(nil,nil,.serverError)
                }else{
                    ///if data is not nil or invalid create image with data or return error
                    guard let data = data, let image = UIImage(data: data) else {
                        completion(nil,nil,.invalidDataError)
                        return
                    }
                    
                    ///store image in cached images
                    self.cachedImages.setObject(image, forKey: photoURL as NSURL)
                    ///pass image for corresponding indexpath to callback
                    completion(image, indexPath, .none)
                }}
            
        }
        
        task.resume()
    }
    
    
     open func flickrPhotosSearchURL(searchTerm:String)->URL?{
       
       guard let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
           return nil
       }
       
        let searchAPI = "\(Constant.Url.base)?method=\(Constant.Url.photoSearchMethod)&api_key=\(Constant.Url.APIKey)&text=\(encodedSearchTerm)&format=json&nojsoncallback=1"
       guard let flickrURL = URL(string: searchAPI) else {
           return nil
       }
       
       return flickrURL
   }
  
}
