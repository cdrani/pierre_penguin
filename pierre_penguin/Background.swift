//
//  Background.swift
//  pierre_penguin
//
//  Created by cdrainxv on 2017-09-26.
//  Copyright © 2017 cdrainxv. All rights reserved.
//

import Foundation
import SpriteKit

class Background: SKSpriteNode {
    // Indicate how fast background should move past:
    // 0 is full adjustment ---> no movement as world goes past
    // 1 is no adjustment ---> normal speed
    var movementMultiplier = CGFloat(0)
    // Store how many points (x-direction) background has jumped forward
    var jumpAdjustment = CGFloat(0)
    let backgroundSize = CGSize(width: 1024, height: 768)
    var textureAtlas = SKTextureAtlas(named: "Backgrounds")
    
    func spawn(parentNode:SKNode, imageName:String, zPosition:CGFloat, movementMultiplier:CGFloat) {
        self.anchorPoint = CGPoint.zero
        // Start backgrounds at top of ground
        self.position = CGPoint(x: 0, y: 30)
        // Control order of backgrounds
        self.zPosition = zPosition
        
        self.movementMultiplier = movementMultiplier
        parentNode.addChild(self)
        let texture = textureAtlas.textureNamed(imageName)
        
        // Backgrounds should cover both forward and behind the player at position zero:
        for i in -1...1 {
            let newBGNode = SKSpriteNode(texture: texture)
            newBGNode.size = backgroundSize
            newBGNode.anchorPoint = CGPoint.zero
            newBGNode.position = CGPoint(
                x: i * Int(backgroundSize.width), y: 0
            )
            self.addChild(newBGNode)
        }
    }
    
    // Reposition the background:
    func updatePosition(playerProgress:CGFloat) {
        let adjustedPosition = jumpAdjustment + playerProgress * (1 - movementMultiplier)
        // Jump background forwards?:
        if playerProgress - adjustedPosition > backgroundSize.width {
            jumpAdjustment += backgroundSize.width
        }
        // Move background forward as camera pans so background appears slower:
        self.position.x = adjustedPosition
    }
}
