//
//  MemoryCell.swift
//  shopify-mobile-challenge
//
//  Created by Philip Tam on 2019-09-17.
//  Copyright © 2019 Philip Tam. All rights reserved.
//

import UIKit

class MemoryCell: UICollectionViewCell {

    @IBOutlet weak var memoryView: UIView!
    @IBOutlet weak var memoryImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func setRevealedImage(url: URL) {
        let session = URLSession.shared;
        session.dataTask(with: url) { (data, response, error) in
            // Check error is nil
            if let error = error {
                print(" Error while fetching image: " + error.localizedDescription)
                return
            }
            guard let data = data  else {
                return
            }
            DispatchQueue.main.async {
                self.memoryImageView.image = UIImage(data: data)
            }
        }.resume()
    }
    
    func setHiddenImage() {
        self.memoryImageView.image = UIImage(named: "totoro_playing_card")
    }
    
    
}
