//
//  ViewController.swift
//  shopify-mobile-challenge
//
//  Created by Philip Tam on 2019-09-15.
//  Copyright © 2019 Philip Tam. All rights reserved.
//

import UIKit

class MemoryController: UIViewController {
    
    @IBOutlet weak var memoryCollectionView: UICollectionView! {
        didSet {
            /*
                Setup function for UICollectionView
            */
            let nib = UINib(nibName: "MemoryCell", bundle: nil)
            self.memoryCollectionView.register(nib, forCellWithReuseIdentifier: "MemoryCell")
            self.memoryCollectionView.delegate = self
            self.memoryCollectionView.dataSource = self
        }
    }
    
    @IBOutlet var shadowViews: [UIView]! {
        didSet {
            for shadowView in self.shadowViews {
                shadowView.layer.shadowColor = UIColor.lightGray.cgColor
                shadowView.layer.shadowOpacity = 0.8
                shadowView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
                shadowView.layer.shadowRadius = 2
            }
        }
    }
    
    @IBOutlet var cornerViews: [UIView]! {
        didSet {
            for cornerView in self.cornerViews {
                cornerView.layer.cornerRadius = 10
            }
        }
    }
    
    @IBOutlet weak var optionsView: UIView!
     @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var scoreView: UIView! 
    @IBOutlet weak var scoreCountLabel: UILabel!

    
    
    @IBOutlet weak var resetButton: HighlighedtButton!
    @IBOutlet weak var shuffleButton: HighlighedtButton!
    
    
    // memoryCard == Products
    var memoryCards: [MemoryCard] = []
    
    var correct: Int = 0 {
        didSet {
            self.scoreCountLabel.text = "\(self.correct)"
        }
    }
    
    var matchesToWin: Int = 10
    var possibleMatches: Int = 16
    var copiesToMatch: Int = 3
    
    // This is to check for the firstID and firstIndexPath
    var id: Int?
    var indexPathArray: [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.fetchData()
    }
    
    func setupUI() {
       // Setup icons for buttons ( shuffle and reset buttons)
        // Set the dark gray tint color
        guard let shuffleIcon = UIImage(named: "shuffle_icon") else {return}
       shuffleButton.setImage(shuffleIcon, for: .normal)
       shuffleButton.imageView?.contentMode = .scaleAspectFit
       shuffleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
       shuffleButton.tintColor = .darkGray
        
        guard let refershIcon = UIImage(named: "refresh_icon") else {return}
       resetButton.setImage(refershIcon, for: .normal)
        resetButton.imageView?.contentMode = .scaleAspectFit
       resetButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
       resetButton.tintColor = .darkGray
    }
    
    func fetchData() {
        // Fetch the product list from the URL List
        DataFetcher.shared.fetchProduct { (success, error) in
            if(success) {
                // Shuffle the memory cards aka products
                self.setupGame()
            }
        }
    }
    
    func setupGame() {
        for product in DataFetcher.shared.productList.products {
            guard let url = URL(string: product.image.src) else {continue}
            for _ in 1...self.copiesToMatch {
                self.memoryCards.append(MemoryCard.init(imageURL: url, id: product.id))
            }
            if(memoryCards.count/self.copiesToMatch == possibleMatches) {
                break
            }
        }
        self.memoryCards.shuffle()
        
        DispatchQueue.main.async {
            self.memoryCollectionView.reloadData()
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: HighlighedtButton) {
        
        self.correct = 0
        UIView.transition(with: self.memoryCollectionView, duration: 0.3, options: [.transitionCrossDissolve], animations: {
                self.memoryCards.removeAll()
                   DispatchQueue.main.async {
                         self.memoryCollectionView.reloadData()
                     }
        }, completion: { (success) in
            UIView.transition(with: self.memoryCollectionView, duration: 0.3, options: [.transitionCrossDissolve], animations: {
                self.setupGame()
            })
        })
    }
    
    /*
     
     
     */
    @IBAction func shuffleButtonPressed(_ sender: HighlighedtButton) {
        if(indexPathArray.count > 0){
            for indexPath in indexPathArray {
                self.memoryCards[indexPath.item].state = .hidden
            }
            indexPathArray.removeAll()
            self.id = nil
        }
        
        self.memoryCards.shuffle()
        guard let visibleCells = self.memoryCollectionView?.visibleCells as? [MemoryCell] else {return}
        for (index, cell) in visibleCells.enumerated() {
            UIView.transition(with: cell, duration: 0.5, options: [.transitionFlipFromTop, .transitionFlipFromBottom], animations: {
                if(self.memoryCards[index].state == .hidden) {
                    cell.setHiddenImage()
                } else {
                    cell.setRevealedImage(url: self.memoryCards[index].imageURL)
                }
           })
        }
    }
    
    @IBAction func optionsButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            self.blurView.alpha = 1
        })
        UIView.animate(withDuration: 0.2, animations: {
            self.optionsView.alpha = 1
        })
    }
    
    func closeOptionView() {
        UIView.animate(withDuration: 0.1, animations: {
            self.blurView.alpha = 0
        })
        UIView.animate(withDuration: 0.2, animations: {
            self.optionsView.alpha = 0
        })
    }
}

/*

 UICollectionViewDelegate, UICollectionViewDataSource
 
*/
extension MemoryController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memoryCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemoryCell", for: indexPath)
        guard let memoryCell = cell as? MemoryCell else {return cell}
        
        let memoryCard = memoryCards[indexPath.item]
        switch memoryCard.state {
        case .hidden:
            memoryCell.setHiddenImage()
            break
        case .shown:
            memoryCell.setRevealedImage(url: memoryCard.imageURL)
            break
        case .revealed:
            memoryCell.setRevealedImage(url: memoryCard.imageURL)
        }
        return memoryCell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let memoryCell = cell as? MemoryCell else {return}
        let memoryCard = self.memoryCards[indexPath.item]
        if(memoryCard.state == .hidden ) {
            memoryCell.setHiddenImage()
        } else {
            memoryCell.setRevealedImage(url: memoryCard.imageURL)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let memoryCell = collectionView.cellForItem(at: indexPath) as? MemoryCell else {return}
        
        // Checks if the firstID (First card has been picked)
            switch self.memoryCards[indexPath.item].state {
            case .hidden:
                if let id = id {
                    if(self.memoryCards[indexPath.item].id == id && (self.indexPathArray.count + 1) == self.copiesToMatch) {
                        self.addCorrect(indexPath: indexPath, memoryCell: memoryCell)
                    } else if(self.memoryCards[indexPath.item].id == id) {
                        self.indexPathArray.append(indexPath)
                        self.setShownCellAnimated(indexPath: indexPath, memoryCell: memoryCell)
                    } else {
                        self.memoryCards[indexPath.item].state = .shown
                        memoryCell.setRevealedImage(url: self.memoryCards[indexPath.item].imageURL)
                        // Disable any other selection
                        collectionView.allowsSelection = false
                        
                        // Run through main thread after 0.7 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            
                            // Allow selections after
                            collectionView.allowsSelection = true
                            
                            self.setHiddenCellAnimated(indexPath: indexPath, memoryCell: memoryCell)
                            
                            for otherIndexPath in self.indexPathArray {
                                let otherMemoryCell = collectionView.cellForItem(at: otherIndexPath) as? MemoryCell
                                self.setHiddenCellAnimated(indexPath: otherIndexPath, memoryCell: otherMemoryCell)
                            }
                            self.id = nil
                            self.indexPathArray = []
                        }
                    }
                } else {
                    self.id = self.memoryCards[indexPath.item].id
                    self.indexPathArray.append(indexPath)
                    
                    self.setShownCellAnimated(indexPath: indexPath, memoryCell: memoryCell)
                }
                break
                // IF it is shown then it means that it is the first index
            case .shown:
                self.id = nil
                self.indexPathArray = []
                self.setHiddenCellAnimated(indexPath: indexPath, memoryCell: memoryCell)
                break
            case .revealed:
                print("Do not touch")
            }
    }
    
    func addCorrect(indexPath: IndexPath, memoryCell: MemoryCell) {
       self.correct += 1
       self.setRevealedCellAnimated(indexPath: indexPath, memoryCell: memoryCell)
        for otherIndexPath in indexPathArray {
            let otherMemoryCell = self.memoryCollectionView.cellForItem(at: otherIndexPath) as? MemoryCell
            self.setRevealedCellAnimated(indexPath: otherIndexPath, memoryCell: otherMemoryCell)
        }
        self.id = nil
        self.indexPathArray = []
       if(self.correct == self.matchesToWin) {
           
       }
    }
    
    func addCopy() {
        
    }
    
    
    /*
        Set Memory Cell to either a playing card or revealed state!
        There is an animated version for clicking vs simply changing or else the other option be an if statement which would always trigger when scrolling
     */
    
    /*
        SetHiddenAnimated
        *indexPath
        *memoryCell
        Will set the Memory Card to hidden and change the image accordingly with an animation
     */
    func setHiddenCellAnimated(indexPath: IndexPath, memoryCell: MemoryCell?) {
        self.memoryCards[indexPath.item].state = .hidden
        if let memoryCell = memoryCell {
            UIView.transition(with: memoryCell.memoryImageView, duration: 0.2, options: [.transitionFlipFromLeft], animations: {
                memoryCell.setHiddenImage()
            })
        }
    }
    
    func setHiddenCell(indexPath: IndexPath, memoryCell: MemoryCell?) {
        self.memoryCards[indexPath.item].state = .hidden
        if let memoryCell = memoryCell {
            memoryCell.setHiddenImage()
        }
    }
    
    func setShownCellAnimated(indexPath: IndexPath, memoryCell: MemoryCell?) {
        self.memoryCards[indexPath.item].state = .shown
        if let memoryCell = memoryCell {
            UIView.transition(with: memoryCell.memoryImageView, duration: 0.2, options: [.transitionFlipFromRight], animations: {
                memoryCell.setRevealedImage(url: self.memoryCards[indexPath.item].imageURL)
            })
        }
    }
    
    func setShownCell(indexPath: IndexPath, memoryCell: MemoryCell?) {
        self.memoryCards[indexPath.item].state = .shown
        if let memoryCell = memoryCell {
            memoryCell.setRevealedImage(url: self.memoryCards[indexPath.item].imageURL)
        }
    }
    
    func setRevealedCell(indexPath: IndexPath, memoryCell: MemoryCell?) {
        self.memoryCards[indexPath.item].state = .revealed
        if let memoryCell = memoryCell {
                memoryCell.setRevealedImage(url: self.memoryCards[indexPath.item].imageURL)
        }
    }
    
    func setRevealedCellAnimated(indexPath: IndexPath, memoryCell: MemoryCell?) {
        self.memoryCards[indexPath.item].state = .revealed
        if let memoryCell = memoryCell {
            UIView.transition(with: memoryCell.memoryImageView, duration: 0.2, options: [.transitionFlipFromRight], animations: {
                memoryCell.setRevealedImage(url: self.memoryCards[indexPath.item].imageURL)
            })
        }
    }
}

extension MemoryController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 10, height: collectionView.frame.size.width / 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

}

