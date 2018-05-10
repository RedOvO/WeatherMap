//
//  RainController.swift
//  Weatherdemo
//
//  Created by Momotani Erika on 2018/4/18.
//  Copyright © 2018 Momotani Erika. All rights reserved.
//

import Foundation
import UIKit

class RainController {
    // main attribute
    var animate: Bool
    var view   : UIView
    
    // rain drops
    var drops: [UIView]
    var dropColor: UIColor
    
    // position
    var startX: CGFloat
    var startY: CGFloat
    var distanceBetweenEachDrop: CGFloat
    var distanceBetweenSameRow: CGFloat
    
    // animator
    var animator: UIDynamicAnimator
    var gravityBehavior: UIGravityBehavior
    
    // timer
    var timer1: Timer
    
    init(view: UIView) {
        // main attribute
        self.view    = view
        self.animate = false
        
        // rain drops
        self.drops = []
        self.dropColor = UIColor(red:0.56, green:0.76, blue:0.85, alpha:1.0)
        
        // position
        let width = self.view.frame.width
        self.startX = 20
        self.startY = -40
        self.distanceBetweenEachDrop = width * 0.048
        self.distanceBetweenSameRow = self.distanceBetweenEachDrop * 2
        
        // animator
        gravityBehavior = UIGravityBehavior()
        gravityBehavior.gravityDirection.dy = 2
        animator = UIDynamicAnimator(referenceView: self.view)
        animator.addBehavior(gravityBehavior)
        
        // timer
        timer1 = Timer()
    }
    
    func start() {
        self.animate = true
        
        self.timer1 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(firstDrop), userInfo: nil, repeats: true)
    }
    
    func stop()  {
        self.animate = false
        self.drops.removeAll()
        self.timer1.invalidate()
    }
    
    @objc func firstDrop() {
        let numberOfDrops = 3
        var removeIndices: [Int] = []
        
        for _ in 0..<numberOfDrops {
            let newX = CGFloat(10 + Int(arc4random_uniform(UInt32(350))))
            let newY = CGFloat(-200 + Int(arc4random_uniform(UInt32(150))))
            let newDrop = UIView()
            newDrop.frame = CGRect(x: newX, y: newY, width: 1, height: 50)
            newDrop.backgroundColor = self.dropColor
            newDrop.layer.borderWidth = 0
            
            self.view.addSubview(newDrop)
            self.drops.append(newDrop)
            self.gravityBehavior.addItem(newDrop)
        }
        
        for i in self.drops.indices {
            if self.drops[i].frame.origin.y > self.view.frame.height {
                removeIndices.append(i)
            }
        }
        
        for i in removeIndices {
            self.gravityBehavior.removeItem(self.drops[i])
            self.drops[i].removeFromSuperview()
            self.drops.remove(at: i)
        }
    }
}
