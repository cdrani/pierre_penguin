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
        // Position from the lover left corner
        self.anchorPoint = .zero
        // set the scene's background to a nice sky blue
        // NOTE: UIColor uses a scale from 0 to 1 for its color
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        
        // create our bee sprite node
        let bee = SKSpriteNode(imageNamed: "bee")
        // size our bee node
        bee.size = CGSize(width: 28, height: 24)
        // position our bee node
        bee.position = CGPoint(x: 250, y: 250)
        // attach our bee to the scene's node tree
        self.addChild(bee)
    }
}
