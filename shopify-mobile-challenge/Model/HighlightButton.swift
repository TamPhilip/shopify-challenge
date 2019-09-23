//
//  HighlightButton.swift
//  shopify-mobile-challenge
//
//  Created by Philip Tam on 2019-09-22.
//  Copyright © 2019 Philip Tam. All rights reserved.
//

import UIKit

class HighlighedtButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            if(self.isHighlighted) {
                self.backgroundColor = .lightGray
                self.tintColor = .black
            } else {
                self.backgroundColor = .white
                self.tintColor = .darkGray
            }
        }
    }
}
