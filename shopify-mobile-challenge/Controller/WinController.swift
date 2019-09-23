//
//  WinController.swift
//  shopify-mobile-challenge
//
//  Created by Philip Tam on 2019-09-22.
//  Copyright © 2019 Philip Tam. All rights reserved.
//

import UIKit

class WinController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var winImageView: UIImageView!
    
    var cards: Int = 0 {
        didSet {
            self.textLabel.text = "Congratulations! You have won by matching \(cards) cards."
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
    
    func setWinImage() {
        winImageView.image = UIImage.gifImageWithName("dancing_totoro")
    }
    
    @IBAction func restart(_ sender: UIButton) {
        guard let parent = self.parent as? MemoryController else {return}
        parent.restartGame()
        winImageView.image = nil
    }
}
