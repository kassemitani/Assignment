//
//  FlickrUITests.swift
//  FlickrUITests
//
//  Created by Kassem Itani on 09/07/2021.
//

import XCTest

class FlickrUITests: XCTestCase {
    var app: XCUIApplication!
    
    lazy var searchBarElement = app.otherElements["searchbar"]
    lazy var imageCollectionViewElement =
        app.collectionViews.matching(identifier: "imagecollectionview").element
    lazy var searchHistoryTableViewElement = app.tables.matching(identifier: "historytableview").element
   
    ///Test case: when state is empty the collectionView should show a text "Search for images on Flickr"
    func testEmptyStateCollectionView() throws {
        XCUIDevice.shared.orientation = .portrait
        XCTAssertTrue(imageCollectionViewElement.exists)
        XCTAssertTrue(imageCollectionViewElement.staticTexts["Search for images on Flickr"].exists)
        
    }
    ///Test case: when user taps in search bar the collection view hides and table view with search history is displayed
    func testCollectionViewTableViewToggle() throws {
        XCUIDevice.shared.orientation = .portrait
        XCTAssertFalse(searchHistoryTableViewElement.exists)
        XCTAssertTrue(imageCollectionViewElement.exists)
        searchBarElement.tap()
        XCTAssertFalse(imageCollectionViewElement.exists)
        XCTAssertTrue(searchHistoryTableViewElement.exists)
    }
    
    ///Test case: when user enters in search bar  "TEST" and API is called to show images in the collectionView
    func testSearchImagesCollectionView() throws {
        XCUIDevice.shared.orientation = .portrait
        searchForTest()
        XCTAssertNotNil(imageCollectionViewElement.cells.images)
        XCTAssertTrue(imageCollectionViewElement.cells.images.count > 0)
        XCTAssertFalse(imageCollectionViewElement.staticTexts["Search for images on Flickr"].exists)
    }
    
    ///Test case: when user enters in search bar  "TEST" and it is saved in history and shown in the history TableView
    func testHistoryTableView() {
        XCUIDevice.shared.orientation = .portrait
        searchForTest()
        searchBarElement.tap()
        XCTAssertTrue(searchHistoryTableViewElement.cells.staticTexts["TEST"].exists)
    }
    
    
    func searchForTest() {
        searchBarElement.tap()
        searchBarElement.typeText("TEST")
        XCUIApplication().keyboards.buttons["search"].tap()
        sleep(2)
    }
    
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    
}
