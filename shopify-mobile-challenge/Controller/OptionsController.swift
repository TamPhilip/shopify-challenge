//
//  OptionsController.swift
//  shopify-mobile-challenge
//
//  Created by Philip Tam on 2019-09-22.
//  Copyright © 2019 Philip Tam. All rights reserved.
//

import UIKit

class OptionsController: UIViewController {

    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var possibleMatchesLabel: UILabel!
    @IBOutlet weak var matchesToWinLabel: UILabel!
    @IBOutlet weak var copiesToMatchLabel: UILabel!
    @IBOutlet weak var totalNumberOfCardsLabel: UILabel!
    
    @IBOutlet weak var possibleMatchesSlider: UISlider!
    
    @IBOutlet weak var matchesToWinSlider: UISlider!
    
    @IBOutlet weak var copiesToMatchSlider: UISlider!
    
    var matchesToWin: Int = 0
    var possibleMatches: Int = 0
    var copiesToMatch: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func setupUI() {
        self.view.clipsToBounds = true
        self.view.layer.masksToBounds = false
        self.view.layer.cornerRadius = 10
         self.view.layer.shadowColor = UIColor.lightGray.cgColor
         self.view.layer.shadowOpacity = 0.8
         self.view.layer.shadowOffset = CGSize(width: 0, height: 2.0)
         self.view.layer.shadowRadius = 2
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        guard let parent = self.parent as? MemoryController else {return}
        parent.closeOptionView()
    }
    

}
