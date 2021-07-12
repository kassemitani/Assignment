//
//  PhotoSearchResponse.swift
//  Flickr
//
//  Created by Kassem Itani on 09/07/2021.
//

import Foundation
class PhotoSearchResponse:Decodable{
    struct Photos:Decodable{
        var page:Int
        var pages:Int
        var perpage:Int
        var total:Int
        var photo:[PhotoModel]
    }
    let photos:Photos
}
