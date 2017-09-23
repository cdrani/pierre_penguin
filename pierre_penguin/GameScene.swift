//
//  GameScene.swift
//  pierre_penguin
//
//  Created by cdrainxv on 2017-09-22.
//  Copyright © 2017 cdrainxv. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        // Make the scene position from its lower left
        // corner, regardless of any other settings:
        self.anchorPoint = .zero
        
        // Instantiate a constant, mySprite, instance of SKSpriteNode
        let mySprite = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        
        // Assign our sprite a postion
        mySprite.position = CGPoint(x: 150, y: 150)
        
        // Add our sprite node into the node tree.
        self.addChild(mySprite)
        
        // Scale up to 4x initial scale
        let demoAction1 = SKAction.scale(to: 4, duration: 5)
        // Rotate 5 radians
        let demoAction2 = SKAction.rotate(byAngle: 5, duration: 5)
        
        // Group the actions
        let actionSequence = SKAction.sequence([demoAction1, demoAction2])
        // Execute the group!
        mySprite.run(actionSequence)
    }
}
