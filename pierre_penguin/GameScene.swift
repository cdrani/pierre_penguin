//
//  GameScene.swift
//  pierre_penguin
//
//  Created by cdrainxv on 2017-09-22.
//  Copyright © 2017 cdrainxv. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let cam = SKCameraNode()
    let ground = Ground()
    let player = Player()
    let coin = Coin()
    let powerUpStar = Star()
    let hud = HUD()
    
    var screenCenterY = CGFloat()
    let initialPlayerPosition = CGPoint(x: 150, y: 250)
    var playerProgress = CGFloat()
    
    let encounterManager = EncounterManager()
    var nextEncounterSpawnPosition = CGFloat(150)
    
    var coinsCollected = 0
    var backgrounds:[Background] = []
    
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
        
        // PowerUp Star
        self.addChild(powerUpStar)
        powerUpStar.position = CGPoint(x: -2000, y: -2000)
        
        // Be informed of contact events
        self.physicsWorld.contactDelegate = self
        
        // Add camera to scene's node tree:
        self.addChild(self.camera!)
        // Position camera above game elements:
        self.camera!.zPosition = 50
        // Create HUD child nodes
        hud.createHudNodes(screenSize: self.size)
        // Add HUD to camera's node tree
        self.camera!.addChild(hud)
        
        // Instantiate 3 backgrounds:
        for _ in 0..<3 {
            backgrounds.append(Background())
        }
        // Spawn the new backgrounds:
        backgrounds[0].spawn(parentNode: self, imageName: "background-front", zPosition: -5, movementMultiplier: 0.75)
        backgrounds[1].spawn(parentNode: self, imageName: "background-middle", zPosition: -10, movementMultiplier: 0.5)
        backgrounds[2].spawn(parentNode: self, imageName: "background-back", zPosition: -15, movementMultiplier: 0.2)
        
        // Instantiate SKEmitterNode w/ PierrPath design:
        if let dotEmitter = SKEmitterNode(fileNamed: "PierrePath") {
            // Position penguin in front of other game objects:
            player.zPosition = 10
            // Place particle zPosition behind the penguin:
            dotEmitter.particleZPosition = -1
            // move emitter with penguin and emit new dot wherever player is:
            player.addChild(dotEmitter)
            // particles should target scene --> thus trail behind as player moves forward:
            dotEmitter.targetNode = self
        }
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
            
            // Each encounter has 10% chance to spawn a star:
            let starRoll = Int(arc4random_uniform(10))
            if starRoll == 0 {
                // Only move star if offscreen:
                if abs(player.position.x - powerUpStar.position.x) > 1200 {
                    let randomYPos = 50 + CGFloat(arc4random_uniform(400))
                    powerUpStar.position = CGPoint(x: nextEncounterSpawnPosition, y: randomYPos)
                    // Remove previous velocity and spin:
                    powerUpStar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    powerUpStar.physicsBody?.angularVelocity = 0
                }
            }
        }
        
        // Position the backgrounds:
        for background in self.backgrounds {
            background.updatePosition(playerProgress: playerProgress)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Each contact has two bodies
        // Find the penguin body first, then use other body to det. type of contact
        let otherBody:SKPhysicsBody
        // Combine the two penguin physics categories into one bitmask
        let penguinMask = PhysicsCategory.penguin.rawValue | PhysicsCategory.damagedPenguin.rawValue
        // Use bitwise AND (&) to find penguin which return
        if (contact.bodyA.categoryBitMask & penguinMask) > 0 {
            // bodyA is the penguin, now test bodyB's type:
            otherBody = contact.bodyB
        } else {
            otherBody = contact.bodyA
        }
        
        // Find type of contact:
        switch otherBody.categoryBitMask {
        case PhysicsCategory.ground.rawValue:
            print("hit the ground")
            player.takeDamage()
            hud.setHealthDisplay(newHealth: player.health)
        case PhysicsCategory.enemy.rawValue:
            print("take damage")
            player.takeDamage()
            hud.setHealthDisplay(newHealth: player.health)
        case PhysicsCategory.coin.rawValue:
            // Cast otherBody's node as coin:
            if let coin = otherBody.node as? Coin {
                // Start animatioin
                coin.collect()
                // Add coin value to counter:
                self.coinsCollected += coin.value
                hud.setCoinCountDisplay(newCoinCount: self.coinsCollected)
                print(self.coinsCollected)
            }
            print("collect a coin")
        case PhysicsCategory.powerup.rawValue:
            print("start the power-up")
            player.starPower()
        default:
            print("contact with no game logic")
        }
    }
    
    func gameOver() {
        // Show restart and main menu buttons
        hud.showButtons()
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
            
            // Check for HUD buttons (restart and menu):
            if nodeTouched.name == "restartGame" {
                // Transition to new version of GameScene to restart game:
                self.view?.presentScene(
                    GameScene(size: self.size), transition: .crossFade(withDuration: 0.6)
                )
            } else if nodeTouched.name == "returnToMenu" {
                // Transition to main menus scene:
                self.view?.presentScene(
                    MenuScene(size: self.size), transition: .crossFade(withDuration: 0.6)
                )
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

enum PhysicsCategory:UInt32 {
    case penguin = 1
    case damagedPenguin = 2
    case ground = 4
    case enemy = 8
    case coin = 16
    case powerup = 32
}
