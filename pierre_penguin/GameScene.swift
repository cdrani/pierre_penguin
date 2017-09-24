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
    // Create a constant cam as a SKCamerNode:
    let cam = SKCameraNode()
    // Create our bee node as a property of GameScene so we can
    // access it throughout the class
    // (Make sure to remove the old bee declaration below)
    let bee = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        self.anchorPoint = .zero
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        
        // Assign the camera to the scene
        self.camera = cam
        
        // Call the new bee function
        self.addTheFlyingBee()
    }
    
    override func didSimulatePhysics() {
        // Keep the camera centered on the bee
        // Notice the ! operator after camera. SKScene's camera
        // is an optional, but we know it is there since we
        // assigned it above in the didMove function. Unwrap this value by
        // using the ! operator after the property name.
        self.camera!.position = bee.position
    }
    
    func addTheFlyingBee() {
        // Position our bee
        bee.position = CGPoint(x: 250, y: 250)
        bee.size = CGSize(width: 28, height: 24)
        // Add the bee to the scene
        self.addChild(bee)
        
        // Find the bee textures from the texture atlas
        let beeAtlas = SKTextureAtlas(named: "Enemies")
        let beeFrames:[SKTexture] = [
            beeAtlas.textureNamed("bee"),
            beeAtlas.textureNamed("bee-fly")
        ]
        // Create a new SKAction to animate between the frames once
        let flyAction = SKAction.animate(with: beeFrames, timePerFrame: 0.14)
        // Create an SKAction to run the flyAction repeatedly
        let beeAction = SKAction.repeatForever(flyAction)
        // Instruct our bee to run the final repeat action:
        bee.run(beeAction)
        
        // Set up new actions to move our bee back and forth:
        let pathLeft = SKAction.moveBy(x: -200, y: -10, duration: 2)
        let pathRight = SKAction.moveBy(x: 200, y: 10, duration: 2)
        // These two scaleX actions flip the texture back and forth
        // Turns the bee to face left and right
        let flipTextureNegative = SKAction.scaleX(to: -1, duration: 0)
        let flipTexturePositive = SKAction.scaleX(to: 1, duration: 0)
        // Combine actions into a cohesive flight sequence four our bee
        let flightOfTheBee = SKAction.sequence([pathLeft, flipTextureNegative, pathRight, flipTexturePositive])
        // Create a looping action that will repeat forever
        let neverEndingFlight = SKAction.repeatForever(flightOfTheBee)
        
        // Run the flight path
        bee.run(neverEndingFlight)
        
        // Add numerous bees
        let bee2 = Bee()
        bee2.position = CGPoint(x: 325, y: 325)
        self.addChild(bee2)
        
        let bee3 = Bee()
        bee3.position = CGPoint(x: 200, y: 325)
        self.addChild(bee3)
        
    }
    
}
