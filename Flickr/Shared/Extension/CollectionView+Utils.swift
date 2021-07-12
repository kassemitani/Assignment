//
//  CollectionView+Utils.swift
//  Flickr
//
//  Created by Kassem Itani on 11/07/2021.
//

import UIKit

extension UICollectionView {

    /// add a label for empty state 
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }
        
    /// remove the text
    func restore() {
        self.backgroundView = nil
    }
}
