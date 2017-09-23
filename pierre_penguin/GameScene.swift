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
        // The SKSprite constructor can set color and size
        // NOTE: UIColor is a UIKit class with built-in color presets
        // NOTE: CGSize is a type we use to set node sizes
        let mySprite = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        
        // Assign our sprite a postion in points, relative to its
        // parent node (in this case, the scene)
        mySprite.position = CGPoint(x: 150, y: 150)
        
        // Finally, we need to add our sprite node into the node tree.
        // Call the SKScene's addChild function to add the node
        // NOTE: In Swift, 'self' is an automatic property
        // on any type instance, exactly equal to the instance itself
        // So in this case, it refers to the GameScene instance
        self.addChild(mySprite)
        
        // Create a new constant for our action instance
        // Use the move action to provide a goal position for a node
        // SpriteKit will tween to the new position over the course of the
        // duration, in this case 5 seconds
        let demoAction1 = SKAction.move(to: CGPoint(x: 300, y: 150), duration: 5)
        
        // Scale up to 4x initial scale
        let demoAction2 = SKAction.scale(to: 4, duration: 5)
        
        // Rotate 5 radians
        let demoAction3 = SKAction.rotate(byAngle: 5, duration: 5)
        
        // group actions
        // let actionGroup = SKAction.group([demoAction1, demoAction2, demoAction3])
        
        // group sequence
        let actionSequence = SKAction.sequence([demoAction1, demoAction2, demoAction3])
        
        // Excute the sequence!
        // mySprite.run(actionGroup)
        mySprite.run(actionSequence)
    }
}
