//
//  Worm.swift
//  NeuralNetworkWithAnimation
//
//  Created by Yukinaga2 on 2017/09/13.
//  Copyright © 2017年 Yukinaga Azuma. All rights reserved.
//

import UIKit

class Worm: UIImageView {

    override func didMoveToSuperview() {
        self.image = UIImage(named: "dragonfly.png")
        let size = 16
        self.frame = CGRect(x: 0, y: 0, width: size, height: size)
    }
    
    func move(x:CGFloat, y:CGFloat){
        self.center = CGPoint(x: x, y: y)
    }
}
