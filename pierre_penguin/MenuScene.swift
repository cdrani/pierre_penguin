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
    }
}
