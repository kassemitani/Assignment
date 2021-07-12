//
//  FlickrTests.swift
//  FlickrTests
//
//  Created by Kassem Itani on 09/07/2021.
//

import XCTest
@testable import Flickr

class FlickrTests: XCTestCase {

    
    ///Test: check search photos API URL is generated correctly
    func testPhotosSearchURLAPI() throws {
        let url =   URL(string:"https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=11c40ef31e4961acf4f98c8ff4e945d7&text=TEST&format=json&nojsoncallback=1")
        let outputURL = ImageSearchService.shared.flickrPhotosSearchURL(searchTerm:"TEST")
        XCTAssertEqual(url, outputURL,"INVALID API URL")
    }
    
    ///Test: check photo API URL is generated correctly
    func testPhotoURLAPI() throws {
        let url = URL(string:"https://farm1.static.flickr.com/578/23451156376_8983a8ebc7.jpg")
        let model = PhotoModel(id:"23451156376" , secret:"8983a8ebc7", server: "578", farm: 1)
        let outputURL = ImageSearchService.shared.flickrphotoURL(photo: model)
        XCTAssertNotNil(outputURL,"INVALID URL")
        XCTAssertEqual(url, outputURL ?? URL(string:""),"INVALID PHOTO URL")
    }
    
    ///Test:  call search photos API  and check the list returned
    func testPhotoSearchAPI() throws {
        let searchTerm = "TEST"
        let expectation = self.expectation(description: "Photo list is returned")
        ImageSearchService.shared.fetchPhotoList(withSearchTerm: searchTerm, completion: { (photoList, error) in
            XCTAssertNotNil(photoList,"photos search response is nil")
            XCTAssertTrue(photoList?.count ?? 0>0, "Empty photos search response")
            expectation.fulfill()
        })
        waitForExpectations(timeout: TimeInterval(10), handler: nil)

    }

    ///Test:  call photo URL  and check if image data is returned
    func testFetchPhoto() throws {
        let expectation = self.expectation(description: "Photo is fetched")
        let url = URL(string: "https://farm1.static.flickr.com/578/23451156376_8983a8ebc7.jpg")
        let inputIndexPath = IndexPath(row: 1, section: 0)
        ImageSearchService.shared.fetchPhoto(photoURL: url!, indexPath: inputIndexPath, completion: { (image, indexPath, error) in
            XCTAssertNotNil(image,"image is nil")
            XCTAssertEqual(inputIndexPath, indexPath,"invalid index path")
            XCTAssertEqual(error,.none,"\(error)")
            expectation.fulfill()
        })

        waitForExpectations(timeout: TimeInterval(10), handler: nil)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
}
