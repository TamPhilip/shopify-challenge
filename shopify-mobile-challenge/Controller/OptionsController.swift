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
    
    var matchesToWin: Int = 0 {
        didSet {
            self.matchesToWinSlider.value = Float(self.matchesToWin)
            self.matchesToWinLabel.text = "\(Int(self.matchesToWin))"
        }
    }
    var possibleMatches: Int = 0 {
        didSet {
            self.possibleMatchesSlider.value = Float(self.possibleMatches)
            self.possibleMatchesLabel.text = "\(Int(self.possibleMatches))"
            totalNumberOfCards()
        }
    }
    var copiesToMatch: Int = 0 {
        didSet {
            self.copiesToMatchSlider.value = Float(self.copiesToMatch)
            self.copiesToMatchLabel.text = "\(Int(self.copiesToMatch))"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func setupUI() {
         self.view.layer.shadowColor = UIColor.lightGray.cgColor
         self.view.layer.shadowOpacity = 0.8
         self.view.layer.shadowOffset = CGSize(width: 0, height: 2.0)
         self.view.layer.shadowRadius = 2
    }
    
    func totalNumberOfCards() {
        self.totalNumberOfCardsLabel.text = "Total number of cards: \(Int(self.copiesToMatchSlider.value) * Int(self.possibleMatchesSlider.value))"
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        guard let parent = self.parent as? MemoryController else {return}
        parent.closeOptionView()
    }
    
    @IBAction func possibleMatchSliderChanged(_ sender: UISlider) {
        self.possibleMatchesLabel.text = "\(Int(self.possibleMatchesSlider.value))"
        totalNumberOfCards()
    }
    
    @IBAction func copiesToMachSliderChanged(_ sender: UISlider) {
        self.copiesToMatchLabel.text = "\(Int(self.copiesToMatchSlider.value))"
        totalNumberOfCards()
    }
    
    @IBAction func matchesToWinSliderChanged(_ sender: Any) {
        self.matchesToWinLabel.text = "\(Int(self.matchesToWinSlider.value))"
    }
    @IBAction func donePressed(_ sender: UIButton) {
        guard let parent = self.parent as? MemoryController else {return}
        parent.optionsDonePressed(possibleMatches: Int(self.possibleMatchesSlider.value), copiesToMatch: Int(self.copiesToMatchSlider.value), matchesToWin: Int(self.matchesToWinSlider.value))
    }
}
