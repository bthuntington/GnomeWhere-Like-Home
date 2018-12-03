//
//  LevelTwoScene.swift
//  GnomeWhere Like Home
//
//  Created by Brooke Huntington on 11/25/18.
//  Copyright © 2018 Brooke Huntington. All rights reserved.
// code used from https://www.raywenderlich.com/1079-what-s-new-in-spritekit-on-ios-10-a-look-at-tile-maps
// picture of grasshopper from https://www.vectorstock.com/royalty-free-vector/isolated-cute-green-grasshopper-vector-18468818
// code for bullets taken from http://developerplayground.net/how-to-implement-a-space-shooter-with-spritekit-and-swift-part-2/


import SpriteKit
import GameplayKit
import UIKit

struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    static let enemy     : UInt32 = 0b1       // 1
    static let projectile: UInt32 = 0b10      // 2
}

class LevelTwoScene: SKScene  {
    
    var bulletsArray = [SKSpriteNode]()
    var dLastShootTime: CFTimeInterval = 1
    //labels for game stats
    var lives = SKLabelNode()
    var seeds = SKLabelNode()
    var waves = SKLabelNode()
    // towers in scene
    var towerSpot1 = SKSpriteNode()
    var towerSpot2 = SKSpriteNode()
    var towerSpot3 = SKSpriteNode()
    var towerSpot4 = SKSpriteNode()
    var towerSpot5 = SKSpriteNode()
    var towerSpot6 = SKSpriteNode()
    var towerSpot7 = SKSpriteNode()
    var towerSpot8 = SKSpriteNode()
    var towerSpot9 = SKSpriteNode()
    // pop up when a user wants to add a tower
    var ladybugOption = SKSpriteNode()
    var grasshopperOption = SKSpriteNode()
    var earthWormOption = SKSpriteNode()
    //
    var enemies = [SKSpriteNode]()
    var towers = [SKSpriteNode]()
    var addEnemiesTime = 30
    // enemies added when they spawn
    // & deleted when they die
    var enemiesOnField = 0
    // time enemies spawn
    var enemiesTimer: Timer? = nil
    // time players get to prepare
    var prepareTimer: Timer? = nil
    // time until the wave is over
    var waveTimer: Timer? = nil
    var prepareTime = 6
    var waveTime = 60
    // true: no options out
    // false: options are out
    var selectTowerOptions = true
    
    override func didMove(to view: SKView) {
//        createButton(x: 0, y: 100)
//        let alert = UIAlertController(title: "GnomeWhere Like Home", message: "Defend the Garden!", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "Start", style: .default, handler: { action in
        
        startPrepareTimer()
//        }))
//        self.parent!.scene!.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
        //addTower(towerName: "towerSpot1")
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        

    }
    
    
    
    func startPrepareTimer() {
        // have timer stop a 0 and start at 60
        prepareTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatePrepareTimer), userInfo: nil, repeats: true)
    }
    
    func startSpawningTimer() {
        // have timer stop a 0 and start at 60
        enemiesTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateEnemies), userInfo: nil, repeats: true)
    }
    
    func startWaveTimer() {
        enemiesTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateWave), userInfo: nil, repeats: true)
    }
    
    @objc func updatePrepareTimer() {
        if prepareTime != 0 {
            prepareTime -= 1
        } else {
            startSpawningTimer()
            prepareTimer?.invalidate()
        }
    }
    // stops the timer a 0
    @objc func updateEnemies() {
        if addEnemiesTime != 0 {
            startWaveTimer()
            addEnemy()
            addEnemiesTime -= 1
        } else {
            enemiesTimer?.invalidate()
        }
    }
    
    @objc func updateWave() {
        if waveTime != 0 {
            waveTime -= 1
        } else {
            waveTimer?.invalidate()
        }
    }
    
    func addEnemy() {
        let enemy = SKSpriteNode(imageNamed:"Blue_Bird_Flying0001")
        enemy.scale(to: CGSize(width: 100, height: 100))
        
        enemies.append(enemy)
        addChild(enemy)
        // Add physics body for collision detection
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size) // 1
        enemy.physicsBody?.isDynamic = true // 2
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy // 3
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // 4
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
        
        enemiesOnField = enemiesOnField + 1
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -250, y: 200))
        path.addLine(to: CGPoint(x: 160, y: 200))
        path.addLine(to: CGPoint(x: 160, y: 0))
        path.addLine(to: CGPoint(x: -125, y: 0))
        path.addLine(to: CGPoint(x: -125, y: -100))
        path.addLine(to: CGPoint(x: 100, y: -100))
        path.addLine(to: CGPoint(x: 100, y: -200))
        path.addLine(to: CGPoint(x: -125, y: -200))
        path.addLine(to: CGPoint(x: -125, y: -350))
        
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 100)
        enemy.run(move)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }

    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        print("touches began at: \(touchedNode.position)")
        if let name = touchedNode.name
        {
            print("name: \(name)")
            // if the options are already up, add choosen texture to tower
            if selectTowerOptions == false {
                print("options false")
                if name == "ladybugOption" {
                    print("option pressed")
                    addLadybugTexture(touchedNode: touchedNode)
                
                }
                if name == "grasshopperOption" {
                    addGrasshopperTexture(touchedNode: touchedNode)
                }
                if name == "earthwormOption" {
                    addEarthwormTexture(touchedNode: touchedNode)
                }
                ladybugOption.removeFromParent()
                grasshopperOption.removeFromParent()
                earthWormOption.removeFromParent()
                selectTowerOptions = true
            // determines which tower to add options too
            } else {
                if name == "towerSpot1"
                {
                    print("tower 1 Touched")
                    giveTowerOptions(towerName: "towerSpot1")
                }
                if name == "towerSpot2"
                {
                    print("tower 2 Touched")
                    giveTowerOptions(towerName: "towerSpot2")
                }
                if name == "towerSpot3"
                {
                    print("tower 3 Touched")
                    giveTowerOptions(towerName: "towerSpot3")
                }
                if name == "towerSpot4"
                {
                    print("tower 4 Touched")
                    giveTowerOptions(towerName: "towerSpot4")
                }
                if name == "towerSpot5"
                {
                    print("tower 5 Touched")
                    giveTowerOptions(towerName: "towerSpot5")
                }
                if name == "towerSpot6"
                {
                    print("tower 6 Touched")
                    giveTowerOptions(towerName: "towerSpot6")
                }
                if name == "towerSpot7"
                {
                    print("tower 7 Touched")
                    giveTowerOptions(towerName: "towerSpot7")
                }
                if name == "towerSpot8"
                {
                    print("tower 8 Touched")
                    giveTowerOptions(towerName: "towerSpot8")
                }
                if name == "towerSpot9"
                {
                    print("tower 9 Touched")
                    giveTowerOptions(towerName: "towerSpot9")
                }
            }
        }
        
    }
    
    // brings up the options based on which tower has been clicked
    func giveTowerOptions(towerName: String) {
        if let tower = self.childNode(withName: towerName) as? SKSpriteNode
        {
            if towerName == "towerSpot1" {
                towerSpot1 = tower
                if tower.texture != SKTexture(imageNamed: "ladybug") &&  tower.texture != SKTexture(imageNamed: "grasshopper") && tower.texture != SKTexture(imageNamed: "earthworm") {
                    createOptions(xStart: -130, y: 190)
                } else {
                    print("already a tower added here")
                }
            }
            if towerName == "towerSpot2" {
                towerSpot2 = tower
                if tower.texture != SKTexture(imageNamed: "ladybug") &&  tower.texture != SKTexture(imageNamed: "grasshopper") && tower.texture != SKTexture(imageNamed: "earthworm") {
                    createOptions(xStart: 30, y: 190)
                } else {
                    print("already a tower added here")
                }
            }
            if towerName == "towerSpot3" {
                towerSpot3 = tower
                if tower.texture != SKTexture(imageNamed: "ladybug") &&  tower.texture != SKTexture(imageNamed: "grasshopper") && tower.texture != SKTexture(imageNamed: "earthworm") {
                    createOptions(xStart: -130, y: 110)
                } else {
                    print("already a tower added here")
                }
            }
            if towerName == "towerSpot4" {
                towerSpot4 = tower
                if tower.texture != SKTexture(imageNamed: "ladybug") &&  tower.texture != SKTexture(imageNamed: "grasshopper") && tower.texture != SKTexture(imageNamed: "earthworm") {
                    createOptions(xStart: 30, y: 110)
                } else {
                    print("already a tower added here")
                }
            }
            if towerName == "towerSpot5" {
                towerSpot5 = tower
                if tower.texture != SKTexture(imageNamed: "ladybug") &&  tower.texture != SKTexture(imageNamed: "grasshopper") && tower.texture != SKTexture(imageNamed: "earthworm") {
                    createOptions(xStart: -130, y: 0)
                } else {
                    print("already a tower added here")
                }
            }
            if towerName == "towerSpot6" {
                towerSpot6 = tower
                if tower.texture != SKTexture(imageNamed: "ladybug") &&  tower.texture != SKTexture(imageNamed: "grasshopper") && tower.texture != SKTexture(imageNamed: "earthworm") {
                    createOptions(xStart: 0, y: 0)
                } else {
                    print("already a tower added here")
                }
            }
            if towerName == "towerSpot7" {
                towerSpot7 = tower
                if tower.texture != SKTexture(imageNamed: "ladybug") &&  tower.texture != SKTexture(imageNamed: "grasshopper") && tower.texture != SKTexture(imageNamed: "earthworm") {
                    createOptions(xStart: -130, y: -110)
                } else {
                    print("already a tower added here")
                }
            }
            if towerName == "towerSpot8" {
                towerSpot8 = tower
                if tower.texture != SKTexture(imageNamed: "ladybug") &&  tower.texture != SKTexture(imageNamed: "grasshopper") && tower.texture != SKTexture(imageNamed: "earthworm") {
                    createOptions(xStart: 0, y: -110)
                } else {
                    print("already a tower added here")
                }
            }
            if towerName == "towerSpot9" {
                towerSpot9 = tower
                if tower.texture != SKTexture(imageNamed: "ladybug") &&  tower.texture != SKTexture(imageNamed: "grasshopper") && tower.texture != SKTexture(imageNamed: "earthworm") {
                    createOptions(xStart: -130, y: -220)
                } else {
                    print("already a tower added here")
                }
            }
        }
    }
    // creates the options based on location tower
    func createOptions(xStart: Int, y: Int) {
        print("options up")
        selectTowerOptions = false
        ladybugOption = SKSpriteNode(texture: SKTexture(imageNamed: "ladybug"), color: .black, size: CGSize(width: 45, height: 45))
        ladybugOption.name = "ladybugOption"
        ladybugOption.position = CGPoint(x: xStart, y: y)
        self.addChild(ladybugOption)
        
        grasshopperOption = SKSpriteNode(texture: SKTexture(imageNamed: "grasshopper"), color: .black, size: CGSize(width: 45, height: 45))
        grasshopperOption.position = CGPoint(x: xStart + 50, y: y)
        grasshopperOption.name = "grasshopperOption"
        self.addChild(grasshopperOption)
        
        earthWormOption = SKSpriteNode(texture: SKTexture(imageNamed: "earthworm"), color: .black, size: CGSize(width: 45, height: 45))
        earthWormOption.position = CGPoint(x: xStart + 100, y: y)
        earthWormOption.name = "earthwormOption"
        self.addChild(earthWormOption)
    }
    
    // determines which tower to add a ladybug texture to
    func addLadybugTexture(touchedNode: SKNode) {
        // row 1
        if touchedNode.position == CGPoint(x: -130.0, y: 190.0) {
            print("adding ladybug")
            towers.append(towerSpot1)
            towerSpot1.texture = SKTexture(imageNamed: "ladybug")
        }
        if touchedNode.position == CGPoint(x: 30.0, y: 190.0) {
            print("adding ladybug")
            towers.append(towerSpot2)
            towerSpot2.texture = SKTexture(imageNamed: "ladybug")
        }
        // row 2
        if touchedNode.position == CGPoint(x: -130.0, y: 110.0) {
            print("adding ladybug")
            towers.append(towerSpot3)
            towerSpot3.texture = SKTexture(imageNamed: "ladybug")
        }
        if touchedNode.position == CGPoint(x: 30.0, y: 110.0) {
            print("adding ladybug")
            towers.append(towerSpot4)
            towerSpot4.texture = SKTexture(imageNamed: "ladybug")
        }
        // row 3
        if touchedNode.position == CGPoint(x: -130.0, y: 0.0) {
            print("adding ladybug")
            towers.append(towerSpot5)
            towerSpot5.texture = SKTexture(imageNamed: "ladybug")
        }
        if touchedNode.position == CGPoint(x: 0.0, y: 0.0) {
            print("adding ladybug")
            towers.append(towerSpot6)
            towerSpot6.texture = SKTexture(imageNamed: "ladybug")
        }
        // row 4
        if touchedNode.position == CGPoint(x: -130.0, y: -110.0) {
            print("adding ladybug")
            towers.append(towerSpot7)
            towerSpot7.texture = SKTexture(imageNamed: "ladybug")
        }
        if touchedNode.position == CGPoint(x: 0.0, y: -110.0) {
            print("adding ladybug")
            towers.append(towerSpot8)
            towerSpot8.texture = SKTexture(imageNamed: "ladybug")
        }
        // end node
        if touchedNode.position == CGPoint(x: -130.0, y: -220.0) {
            print("adding ladybug")
            towers.append(towerSpot9)
            towerSpot9.texture = SKTexture(imageNamed: "ladybug")
        }
    }
    
    // determines which tower to add a grasshopper texture to
    func addGrasshopperTexture(touchedNode: SKNode) {
        // for grasshopper options
        if touchedNode.position == CGPoint(x: -70.0, y: 190.0) {
            print("adding grasshopper")
            towerSpot1.texture = SKTexture(imageNamed: "grasshopper")
        }
    }
    // determimese which tower to add a earthworm texture to
    func addEarthwormTexture(touchedNode: SKNode) {
        // for earthworm options
        if touchedNode.position == CGPoint(x: -20.0, y: 190.0) {
            print("adding earthworm")
            towerSpot1.texture = SKTexture(imageNamed: "earthworm")
        }
    }
    
    // Create bullets
    func shoot(targetSprite: SKSpriteNode) {
        
        for tower in towers {
            // Create the bullet sprite
            let bullet = SKSpriteNode()
            bullet.color = UIColor.green
            bullet.size = CGSize(width: 5,height: 5)
            bullet.position = CGPoint(x: tower.position.x, y: tower.position.y)
            // Add physics body for collision detection
            bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
            bullet.physicsBody?.isDynamic = true
            bullet.physicsBody?.categoryBitMask = PhysicsCategory.projectile
            bullet.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
            bullet.physicsBody?.collisionBitMask = PhysicsCategory.none
            bullet.physicsBody?.usesPreciseCollisionDetection = true

            targetSprite.parent?.addChild(bullet)
            // Determine vector to targetSprite
            let vector = CGVector(dx: targetSprite.position.x-tower.position.x, dy: targetSprite.position.y-tower.position.y)
            
            // Create the action to move the bullet. Don’t forget to remove the bullet!
            let bulletAction = SKAction.sequence([SKAction.repeat(SKAction.move(by: vector, duration: 1), count: 10) ,  SKAction.wait(forDuration: 30.0/60.0), SKAction.removeFromParent()])
            bullet.run(bulletAction)
            
            bulletsArray.append(bullet)
            
        }
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        // shoot in direction of first enemy added
        if enemiesOnField > 0 {
            
            if (currentTime - dLastShootTime) >= 1 {
                shoot(targetSprite: enemies[0])
                dLastShootTime=currentTime
            }
        }
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        print("enemy hit")
        
    }

    
    func projectileDidCollideWithEnemy(projectile: SKSpriteNode, enemy: SKSpriteNode) {
        print("Hit")
        projectile.removeFromParent()
        enemy.removeFromParent()
        enemies.removeFirst()
    }
    
}

extension LevelTwoScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.enemy != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
            if let enemy = firstBody.node as? SKSpriteNode,
                let projectile = secondBody.node as? SKSpriteNode {
                projectileDidCollideWithEnemy(projectile: projectile, enemy: enemy)
            }
        }
    }
}
