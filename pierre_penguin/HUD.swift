//
//  HUD.swift
//  pierre_penguin
//
//  Created by cdrainxv on 2017-09-26.
//  Copyright © 2017 cdrainxv. All rights reserved.
//

import Foundation
import SpriteKit

class HUD: SKNode {
    var textureAtlas = SKTextureAtlas(named: "HUD")
    var coinAtlas = SKTextureAtlas(named: "Environment")
    // Keep track of hearts
    var heartNodes:[SKSpriteNode] = []
    // Print the coin score:
    let coinCountText = SKLabelNode(text: "000000")
    
    func createHudNodes(screenSize:CGSize) {
        let cameraOrigin = CGPoint(
            x: screenSize.width / 2, y: screenSize.height / 2)
        
        // --- Coin counter ---
        let coinIcon = SKSpriteNode(texture: coinAtlas.textureNamed("coin-bronze"))
        // Size and position the coin:
        let coinPosition = CGPoint(
            x: -cameraOrigin.x + 23, y: cameraOrigin.y - 23
        )
        coinIcon.size = CGSize(width: 26, height: 26)
        coinIcon.position = coinPosition
        // Configure coin text label:
        coinCountText.fontName = "AvenirNext-HeavyItalic"
        let coinTextPosition = CGPoint(
            x: -cameraOrigin.x + 41, y: coinPosition.y
        )
        coinCountText.position = coinTextPosition
        
        // Align text relative to label node's position:
        coinCountText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        coinCountText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(coinCountText)
        self.addChild(coinIcon)
        
        // Create heart nodes for life meter:
        for index in 0 ..< 3 {
            let newHeartNode = SKSpriteNode(texture: textureAtlas.textureNamed("heart-full"))
            newHeartNode.size = CGSize(width: 46, height: 40)
            // Position hearts below coins:
            let xPos = -cameraOrigin.x + CGFloat(index * 58) + 33
            let yPos = cameraOrigin.y - 66
            newHeartNode.position = CGPoint(x: xPos, y: yPos)
            
            // Keep track of nodes:
            heartNodes.append(newHeartNode)
            self.addChild(newHeartNode)
        }
    }
    
    func setCoinCountDisplay(newCoinCount:Int) {
        // Pad leading 0's onto coin count:
        let formatter = NumberFormatter()
        let number = NSNumber(value: newCoinCount)
        formatter.minimumIntegerDigits = 6
        if let coinStr = formatter.string(from: number) {
            // Update label w/ new count:
            coinCountText.text = coinStr
        }
    }
    
    func setHealthDisplay(newHealth:Int) {
        // fade SKAction to fade hearts:
        let fadeAction = SKAction.fadeAlpha(to: 0.2, duration: 0.3)
        // Update each heart's status:
        for index in 0 ..< heartNodes.count {
            if index < newHealth {
                // This heart should be fully red (opaque):
                heartNodes[index].alpha = 1
            } else {
                // faded:
                heartNodes[index].run(fadeAction)
            }
        }
    }
}
