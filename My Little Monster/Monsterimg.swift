//
//  Monsterimg.swift
//  My Little Monster
//
//  Created by Dishank on 1/2/16.
//  Copyright © 2016 Dishank. All rights reserved.
//

import Foundation
import UIKit

class MonsterImg: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playIdleAnimation()
    }
    
    
    func playIdleAnimation() {
        
        self.image = UIImage(named: "idle (1).png")
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        for var i = 1; i <= 4; i++ {
            let img = UIImage(named: "idle (\(i)).png")
            imgArray.append(img!)
        }
    
        self.animationImages = imgArray
        self.animationDuration = 0.75
        self.animationRepeatCount = -1
        self.startAnimating()
    }
    
    func playDeadAnimation() {
        
        self.image = UIImage(named: "dead5.png")
        self.animationImages = nil
        var imgArray = [UIImage]()
        for var i = 1; i <= 5; i++ {
            let img = UIImage(named: "dead\(i).png")
            imgArray.append(img!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.75
        self.animationRepeatCount = 1
        self.startAnimating()
    }
}

