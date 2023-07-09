//
//  CustomButton.swift
//  IPLights
//
//  Created by Zeljko J on 07/02/2020.
//  Copyright © 2020 Zeljko J. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    var color: UIColor = UIColor.red
    let arr:[UIColor] = [UIColor.gray, UIColor.green,  UIColor.orange]

    func setColor(par:Int) {
        color = arr[par]
        self.setNeedsDisplay()
    }
    override func draw(_ rect:CGRect){
        super.draw(rect)
        
    }

}
