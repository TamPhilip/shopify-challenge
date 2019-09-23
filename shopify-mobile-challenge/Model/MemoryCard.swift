//
//  MemoryCard.swift
//  shopify-mobile-challenge
//
//  Created by Philip Tam on 2019-09-19.
//  Copyright © 2019 Philip Tam. All rights reserved.
//

import Foundation

/*
 
 
 
 */
struct MemoryCard {
    
    enum State {
        case hidden
        case shown
        case revealed
    }
    
    var state: State
    var imageURL: URL
    var id: Int
    
    init(imageURL: URL, id: Int) {
        self.state = .hidden
        self.imageURL = imageURL
        self.id = id
    }
}
