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
    let cam = SKCameraNode()
    let ground = Ground()
    let player = Player()
    
    override func didMove(to view: SKView) {
        self.anchorPoint = .zero
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        
        // Assign the camera to the scene
        self.camera = cam
        
        // Spawn test bees:
        let bee2 = Bee()
        bee2.position = CGPoint(x: 325, y: 325)
        self.addChild(bee2)
        let bee3 = Bee()
        bee3.position = CGPoint(x: 200, y: 325)
        self.addChild(bee3)
    
        // Position ground based on screen size
        // Position X: Negative one screen width
        // Postion Y: 150 above the bottom ( top left anchor point)
        ground.position = CGPoint(x: -self.size.width * 2, y: 30)
        // Set ground width to 3x width of scene
        // height can be 0, child nodes will create height
        ground.size = CGSize(width: self.size.width * 6, height: 0)
        // Run ground's createChildren func to build child texture tiles
        ground.createChildren()
        // Add ground node to scene:
        self.addChild(ground)
        
        // Add player to scene:
        player.position = CGPoint(x: 150, y: 250)
        self.addChild(player)
    }
    
    override func didSimulatePhysics() {
        // Keep the camera centered on the player
        self.camera!.position = player.position
    }
    
    override func update(_ currentTime: TimeInterval) {
        player.update()
    }
}
