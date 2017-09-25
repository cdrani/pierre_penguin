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
    
    var screenCenterY = CGFloat()
    let initialPlayerPosition = CGPoint(x: 150, y: 250)
    var playerProgress = CGFloat()
    
    let encounterManager = EncounterManager()
    var nextEncounterSpawnPosition = CGFloat(150)
    
    override func didMove(to view: SKView) {
        self.anchorPoint = .zero
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        
        // Assign the camera to the scene
        self.camera = cam
        
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
        player.position = initialPlayerPosition
        self.addChild(player)
        
        // Set gravity
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        
        // Vertical center of the screen:
        screenCenterY = self.size.height / 2
        
        // Add encounter nodes as child of GameScene node
        encounterManager.addEncountersToScene(gameScene: self)
    }
    
    override func didSimulatePhysics() {
        // Keep the camera locked at mid screen by default:
        var cameraYPos = screenCenterY
        cam.yScale = 1
        cam.xScale = 1
        
        // Keep track of how far player has flown:
        playerProgress = player.position.x - initialPlayerPosition.x
        
        // Follow player up if on upper half of screen:
        if (player.position.y > screenCenterY) {
            cameraYPos = player.position.y
            // Scale out the camera as player goes higher:
            let percentOfMaxHeight = (player.position.y - screenCenterY) / (player.maxHeight - screenCenterY)
            let newScale = 1 + percentOfMaxHeight
            cam.yScale = newScale
            cam.xScale = newScale
        }
        // Move camera for above adjustments:
        self.camera!.position = CGPoint(x: player.position.x, y: cameraYPos)
        
        // Check if ground should jump forward:
        ground.checkForReposition(playerProgress: playerProgress)
        
        // Check if new encounter should be set:
        if player.position.x > nextEncounterSpawnPosition {
            encounterManager.placeNextEncounter(currentXPos: nextEncounterSpawnPosition)
            nextEncounterSpawnPosition += 1200
        }
    }
    
    // finger on screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            // Locate the touch area:
            let location = touch.location(in: self)
            // Locate node at the location:
            let nodeTouched = atPoint(location)
            // Attempt to downcast the node to the GameSprite protocol:
            if let gameSprite = nodeTouched as? GameSprite {
                // if node adhered to protocol
                gameSprite.onTap()
            }
        }
        player.startFlapping()
    }
    
    // finger lifted from screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFlapping()
    }
    
    // stop flapping when iOS interrupts
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFlapping()
    }
    
    override func update(_ currentTime: TimeInterval) {
        player.update()
    }
}
