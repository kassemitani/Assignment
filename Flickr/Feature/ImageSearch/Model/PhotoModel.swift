//
//  ImageSearchModel.swift
//  Flickr
//
//  Created by Kassem Itani on 09/07/2021.
//

import Foundation

struct PhotoModel: Decodable {
    var id:String
    var secret:String
    var server:String
    var farm:Int
}
