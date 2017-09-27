//
//  MenuScene.swift
//  pierre_penguin
//
//  Created by cdrainxv on 2017-09-26.
//  Copyright © 2017 cdrainxv. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene:SKScene {
    let textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "HUD")
    let startButton = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        // Position nodes from center of scene:
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let backgroundImage = SKSpriteNode(imageNamed: "background-menu")
        backgroundImage.size = CGSize(width: 1024, height: 768)
        backgroundImage.zPosition = -1
        self.addChild(backgroundImage)
        
        // Draw name of game:
        let logoText = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        logoText.text = "Pierre Penguin"
        logoText.position = CGPoint(x: 0, y: 100)
        logoText.fontSize = 60
        self.addChild(logoText)
        // Add another line below:
        let logoTextBottom = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        logoTextBottom.text = "Escapes the Antartic"
        logoTextBottom.position = CGPoint(x: 0, y: 50)
        logoTextBottom.fontSize = 40
        self.addChild(logoTextBottom)
        
        // Build start game button:
        startButton.texture = textureAtlas.textureNamed("button")
        startButton.size = CGSize(width: 295, height: 76)
        // Name the start node for touch detection:
        startButton.name = "StartBtn"
        startButton.position = CGPoint(x: 0, y: -20)
        self.addChild(startButton)
        
        // Add text to the start button:
        let startText = SKLabelNode(fontNamed: "AvenirNext-HeavyItalic")
        startText.text = "START GAME"
        startText.verticalAlignmentMode = .center
        startText.position = CGPoint(x: 0, y: 2)
        startText.fontSize = 40
        // Name the text node for touch detection:
        startText.name = "StartBtn"
        startText.zPosition = 5
        startButton.addChild(startText)
        
        // Pulse start text in and out:
        let pulseAction = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 0.9),
            SKAction.fadeAlpha(to: 1, duration: 0.9)
            ])
        startText.run(SKAction.repeatForever(pulseAction))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            // Find location of touch:
            let location = touch.location(in: self)
            // Locate node at this location
            let nodeTouched = atPoint(location)
            if nodeTouched.name == "StartBtn" {
                // start text or button touched
                // Switch to instance of game scene:
                self.view?.presentScene(GameScene(size: self.size))
            }
        }
    }
}
