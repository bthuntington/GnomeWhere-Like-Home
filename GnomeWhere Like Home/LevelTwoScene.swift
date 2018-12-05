//
//  LevelTwoScene.swift
//  GnomeWhere Like Home
//
//  Created by Brooke Huntington on 11/25/18.
//  Copyright © 2018 Brooke Huntington. All rights reserved.
// picture of grasshopper from https://www.vectorstock.com/royalty-free-vector/isolated-cute-green-grasshopper-vector-18468818
// code for bullets based on http://developerplayground.net/how-to-implement-a-space-shooter-with-spritekit-and-swift-part-2/
// & https://www.raywenderlich.com/71-spritekit-tutorial-for-beginners
//use AVFoundation for music


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
    
    class Enemy: SKSpriteNode {
        
        var hits = Int()
        var strength = Int()
    }
    class Bullet: SKSpriteNode {
        var parentTower = SKSpriteNode()
    }
    
    var prepareLabel = SKLabelNode()
    
    var bulletsArray = [Bullet]()
    var dLastShootTime: CFTimeInterval = 1
    //labels for game stats
    var livesLabel = SKLabelNode()
    var seedsLabel = SKLabelNode()
    var wavesLabel = SKLabelNode()
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
    var enemies = [Enemy]()
    var towers = [SKSpriteNode]()
    var addEnemiesTime = 10
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
    var waveTime = 30
    // true: no options out
    // false: options are out
    var selectTowerOptions = true
    var seeds = 24 {
        didSet {
            seedsLabel.text = "Seeds: \(seeds)"
        }
    }
    var lives = 10 {
        didSet {
            if lives == 0 {
                print("Oh no! The bugs ate all the plants in the garden! Game Over!")
                prepareLabel.text = "Game Over. The bugs ate all the plants"
                livesLabel.text = "Plants: 0"
                waveTimer?.invalidate()
                waveTimer = nil
                isPaused = true
                
            } else {
                livesLabel.text = "Plants: \(lives)"
            }
        }
    }
    var waves = 10 {
        didSet {
            if waves < 1 && enemies.count == 0 {
                wavesLabel.text = "Waves Left: 0"
                prepareLabel.text = "Success! You defended the garden!"
                isPaused = true
            } else {
                wavesLabel.text = "Waves Left: \(waves)"
            }
        }
    }
    
    override func didMove(to view: SKView) {
//        createButton(x: 0, y: 100)
//        let alert = UIAlertController(title: "GnomeWhere Like Home", message: "Defend the Garden!", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "Start", style: .default, handler: { action in
        
//        }))
//        self.parent!.scene!.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
        //addTower(towerName: "towerSpot1")
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        // connecting to labels
        livesLabel = self.childNode(withName: "lives") as! SKLabelNode
        livesLabel.text = "Plants in Garden: \(lives)"
        seedsLabel = self.childNode(withName: "seeds") as! SKLabelNode
        seedsLabel.text = "Seeds: \(24)"
        wavesLabel = self.childNode(withName: "waves") as! SKLabelNode
        wavesLabel.text = "Waves Left: \(waves)"
        startGame()

    }
    
    func startGame() {
        print("starting")
        waves = waves - 1
        // put in code to create waves
        if waves > 0 {
            startPrepareTimer()
        } else {
//            prepareLabel.text = "Success! You defended the garden!"
        }
    }
    
    
    func startPrepareTimer() {
        print("starting wave \(waves)")
        // have timer stop a 0 and start at 60
        if prepareLabel.fontSize != 24 {
            prepareLabel.fontSize = 24
            self.addChild(prepareLabel)
        }
        prepareTime = 6
        prepareTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatePrepareTimer), userInfo: nil, repeats: true)
    }
    
    func startSpawningTimer() {
        // have timer stop a 0 and start at 60
        addEnemiesTime = 10
        enemiesTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateEnemies), userInfo: nil, repeats: true)
    }
    
    func startWaveTimer() {
        waveTime = 30
        if waveTimer == nil {
            waveTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateWave), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updatePrepareTimer() {
        if prepareTime != 0 {
            prepareLabel.text =  "Prepare Time! \(prepareTime) seconds left"
            prepareTime -= 1
        } else {
            startSpawningTimer()
            prepareTimer?.invalidate()
            prepareTimer = nil
            prepareLabel.text = ""
        }
    }
    // stops the timer a 0
    @objc func updateEnemies() {
        if enemies.count < 1 && addEnemiesTime == 10 {
            startWaveTimer()
        }
        if addEnemiesTime != 0 {
            addEnemy()
            addEnemiesTime -= 1
        } else {
            enemiesTimer?.invalidate()
            enemiesTimer = nil
        }
    }
    
    @objc func updateWave() {

        if addEnemiesTime == 0 && enemies.count == 0 {
            print("all enemies dead, next wave")
            waveTimer?.invalidate()
            waveTimer = nil
            startGame()
        } else if waveTime != 0 {
            print(waveTime)
            waveTime -= 1
        } else {
            waveTimer?.invalidate()
            waveTimer = nil
            startGame()
        }
    }
    
    func addEnemy() {
        var enemy = Enemy()
        if waves == 1 {
            enemy = Enemy(imageNamed: "ladybug")
            enemy.scale(to: CGSize(width: 50, height: 50))
            enemy.strength = 3
            enemy.speed = 0.5
        } else if waves < 5 {
            enemy = Enemy(imageNamed: "earthworm")
            enemy.scale(to: CGSize(width: 50, height: 50))
            enemy.speed = 2
        } else {
            enemy = Enemy(imageNamed:"Blue_Bird_Flying0001")
            enemy.scale(to: CGSize(width: 100, height: 100))
            enemy.strength = 2
        }
        
        
        enemies.append(enemy)
        addChild(enemy)
        // Add physics body for collision detection
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size) // 1
        enemy.physicsBody?.isDynamic = true // 2
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy // 3
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // 4
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
        
        enemiesOnField = enemiesOnField + 1
        
        // path for enemies to traverse
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        if let name = touchedNode.name
        {
            // if the options are already up, add choosen texture to tower
            if selectTowerOptions == false {
                if name == "ladybugOption" {
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

                if let stringTower = tower.texture {
                    print(stringTower)
                    print("already a tower" )
                } else {
                    createOptions(xStart: -130, y: 190)
                }
            }
            if towerName == "towerSpot2" {
                towerSpot2 = tower
                if let stringTower = tower.texture {
                    print(stringTower)
                    print("already a tower" )
                } else {
                    createOptions(xStart: 30, y: 190)
                }
            }
            if towerName == "towerSpot3" {
                towerSpot3 = tower
                if let stringTower = tower.texture {
                    print(stringTower)
                    print("already a tower" )
                } else {
                    createOptions(xStart: -130, y: 110)
                }
            }
            if towerName == "towerSpot4" {
                towerSpot4 = tower
                if let stringTower = tower.texture {
                    print(stringTower)
                    print("already a tower" )
                } else {
                    createOptions(xStart: 30, y: 110)
                }
            }
            if towerName == "towerSpot5" {
                towerSpot5 = tower
                if let stringTower = tower.texture {
                    print(stringTower)
                    print("already a tower" )
                } else {
                    createOptions(xStart: -130, y: 0)
                }
            }
            if towerName == "towerSpot6" {
                towerSpot6 = tower
                if let stringTower = tower.texture {
                    print(stringTower)
                    print("already a tower" )
                } else {
                    createOptions(xStart: 0, y: 0)
                }
            }
            if towerName == "towerSpot7" {
                towerSpot7 = tower
                if let stringTower = tower.texture {
                    print(stringTower)
                    print("already a tower" )
                } else {
                    createOptions(xStart: -130, y: -110)
                }
            }
            if towerName == "towerSpot8" {
                towerSpot8 = tower
                if let stringTower = tower.texture {
                    print(stringTower)
                    print("already a tower" )
                } else {
                    createOptions(xStart: 0, y: -110)
                }
            }
            if towerName == "towerSpot9" {
                towerSpot9 = tower
                if let stringTower = tower.texture {
                    print(stringTower)
                    print("already a tower" )
                } else {
                    createOptions(xStart: -130, y: -220)
                }
            }
        }
    }
    // creates the options based on location tower
    func createOptions(xStart: Int, y: Int) {
        if seeds > 11 {
            selectTowerOptions = false
            ladybugOption = SKSpriteNode(texture: SKTexture(imageNamed: "ladybug"), color: .black, size: CGSize(width: 45, height: 45))
            ladybugOption.name = "ladybugOption"
            ladybugOption.position = CGPoint(x: xStart, y: y)
            self.addChild(ladybugOption)
        }
        if seeds > 19 {
            grasshopperOption = SKSpriteNode(texture: SKTexture(imageNamed: "grasshopper"), color: .black, size: CGSize(width: 45, height: 45))
            grasshopperOption.position = CGPoint(x: xStart + 50, y: y)
            grasshopperOption.name = "grasshopperOption"
            self.addChild(grasshopperOption)
        }
        if seeds > 29 {
            earthWormOption = SKSpriteNode(texture: SKTexture(imageNamed: "earthworm"), color: .black, size: CGSize(width: 45, height: 45))
            earthWormOption.position = CGPoint(x: xStart + 100, y: y)
            earthWormOption.name = "earthwormOption"
            self.addChild(earthWormOption)
        }
    }
    
    // determines which tower to add a ladybug texture to
    func addLadybugTexture(touchedNode: SKNode) {
        // row 1
        print("adding ladybug")
        seeds = seeds - 12
        if touchedNode.position == CGPoint(x: -130.0, y: 190.0) {
            towerSpot1.texture = SKTexture(imageNamed: "ladybug")
            towers.append(towerSpot1)
        }
        if touchedNode.position == CGPoint(x: 30.0, y: 190.0) {
            towerSpot2.texture = SKTexture(imageNamed: "ladybug")
            towers.append(towerSpot2)
        }
        // row 2
        if touchedNode.position == CGPoint(x: -130.0, y: 110.0) {
            towerSpot3.texture = SKTexture(imageNamed: "ladybug")
            towers.append(towerSpot3)
        }
        if touchedNode.position == CGPoint(x: 30.0, y: 110.0) {
            towerSpot4.texture = SKTexture(imageNamed: "ladybug")
            towers.append(towerSpot4)
        }
        // row 3
        if touchedNode.position == CGPoint(x: -130.0, y: 0.0) {
            towerSpot5.texture = SKTexture(imageNamed: "ladybug")
            towers.append(towerSpot5)
        }
        if touchedNode.position == CGPoint(x: 0.0, y: 0.0) {
            towers.append(towerSpot6)
            towerSpot6.texture = SKTexture(imageNamed: "ladybug")
        }
        // row 4
        if touchedNode.position == CGPoint(x: -130.0, y: -110.0) {
            towerSpot7.texture = SKTexture(imageNamed: "ladybug")
            towers.append(towerSpot7)
        }
        if touchedNode.position == CGPoint(x: 0.0, y: -110.0) {
            towerSpot8.texture = SKTexture(imageNamed: "ladybug")
            towers.append(towerSpot8)
        }
        // end node
        if touchedNode.position == CGPoint(x: -130.0, y: -220.0) {
            towerSpot9.texture = SKTexture(imageNamed: "ladybug")
            towers.append(towerSpot9)
        }
    }
    
    // determines which tower to add a grasshopper texture to
    func addGrasshopperTexture(touchedNode: SKNode) {
        // for grasshopper options
        // row 1
        seeds = seeds - 20
        print("adding grasshopper")
        if touchedNode.position == CGPoint(x: -80.0, y: 190.0) {
            towerSpot1.texture = SKTexture(imageNamed: "grasshopper")
            towers.append(towerSpot1)
        }
        if touchedNode.position == CGPoint(x: 80.0, y: 190.0) {
            towerSpot2.texture = SKTexture(imageNamed: "grasshopper")
            towers.append(towerSpot2)
        }
        //row 2
        if touchedNode.position == CGPoint(x: -80.0, y: 110.0) {
            towerSpot3.texture = SKTexture(imageNamed: "grasshopper")
            towers.append(towerSpot3)
        }
        if touchedNode.position == CGPoint(x: 80.0, y: 110.0) {
            towerSpot4.texture = SKTexture(imageNamed: "grasshopper")
            towers.append(towerSpot4)
        }
        //row 3
        if touchedNode.position == CGPoint(x: -80.0, y: 0.0) {
            towerSpot5.texture = SKTexture(imageNamed: "grasshopper")
            towers.append(towerSpot5)
        }
        if touchedNode.position == CGPoint(x: 50.0, y: 0.0) {
            towerSpot6.texture = SKTexture(imageNamed: "grasshopper")
            towers.append(towerSpot6)
        }
        //row 4
        if touchedNode.position == CGPoint(x: -80.0, y: -110.0) {
            towerSpot7.texture = SKTexture(imageNamed: "grasshopper")
            towers.append(towerSpot7)
        }
        if touchedNode.position == CGPoint(x: 50.0, y: -110.0) {
            towerSpot8.texture = SKTexture(imageNamed: "grasshopper")
            towers.append(towerSpot8)
        }
        // last node
        if touchedNode.position == CGPoint(x: -80.0, y: -220.0) {
            towerSpot9.texture = SKTexture(imageNamed: "grasshopper")
            towers.append(towerSpot9)
        }
    }
    
    // determimese which tower to add a earthworm texture to
    func addEarthwormTexture(touchedNode: SKNode) {
        // for earthworm options
        seeds = seeds - 30
        print("adding earthworm")
        print(touchedNode.position)
        // row 1
        if touchedNode.position == CGPoint(x: -30.0, y: 190.0) {
            towerSpot1.texture = SKTexture(imageNamed: "earthworm")
            towers.append(towerSpot1)
        }
        if touchedNode.position == CGPoint(x: 130.0, y: 190.0) {
            towerSpot2.texture = SKTexture(imageNamed: "earthworm")
            towers.append(towerSpot2)
        }
        // row 2
        if touchedNode.position == CGPoint(x: -30.0, y: 110.0) {
            towerSpot3.texture = SKTexture(imageNamed: "earthworm")
            towers.append(towerSpot3)
        }
        if touchedNode.position == CGPoint(x: 130.0, y: 190.0) {
            towerSpot4.texture = SKTexture(imageNamed: "earthworm")
            towers.append(towerSpot4)
        }
        // row 3
        if touchedNode.position == CGPoint(x: -30.0, y: 0.0) {
            towerSpot5.texture = SKTexture(imageNamed: "earthworm")
            towers.append(towerSpot5)
        }
        if touchedNode.position == CGPoint(x: 100.0, y: 0.0) {
            towerSpot6.texture = SKTexture(imageNamed: "earthworm")
            towers.append(towerSpot6)
        }
        // row 4
        if touchedNode.position == CGPoint(x: -30.0, y: -110.0) {
            towerSpot7.texture = SKTexture(imageNamed: "earthworm")
            towers.append(towerSpot7)
        }
        if touchedNode.position == CGPoint(x: 100.0, y: -110.0) {
            towerSpot8.texture = SKTexture(imageNamed: "earthworm")
            towers.append(towerSpot8)
        }
        // last node
        if touchedNode.position == CGPoint(x: -30.0, y: -220.0) {
            towerSpot9.texture = SKTexture(imageNamed: "earthworm")
            towers.append(towerSpot9)
        }
    }
    
    // Create bullets
    func shoot(targetSprite: SKSpriteNode) {
        
        for tower in towers {

            // Create the bullet sprite
            let bullet = Bullet()
            bullet.parentTower = tower
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
            var bulletAction = SKAction()
            if String(describing: tower.texture!) == "<SKTexture> 'ladybug' (56 x 56)" {
                bulletAction = SKAction.sequence([SKAction.repeat(SKAction.move(by: vector, duration: 1), count: 10) ,  SKAction.wait(forDuration: 30.0/60.0), SKAction.removeFromParent()])
                bullet.run(bulletAction)
            } else if String(describing: tower.texture!) == "<SKTexture> 'grasshopper' (77 x 77)" {
                bulletAction = SKAction.sequence([SKAction.repeat(SKAction.move(by: vector, duration: 1), count: 10) ,  SKAction.wait(forDuration: 30.0/60.0), SKAction.removeFromParent()])
            } else if String(describing: tower.texture!) == "<SKTexture> 'earthworm' (77 x 77)" {
                bulletAction = SKAction.sequence([SKAction.repeat(SKAction.move(by: vector, duration: 1), count: 10) ,  SKAction.wait(forDuration: 30.0/60.0), SKAction.removeFromParent()])
            } else {
                print("no texture... somehow")
            }
            // Create the action to move the bullet. Don’t forget to remove the bullet!
            bullet.run(bulletAction)
            
            bulletsArray.append(bullet)
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        // shoot in direction of first enemy added
        if enemiesOnField > 0 {
            
            if (currentTime - dLastShootTime) >= 1 {
                
                if enemies.first != nil {
                    shoot(targetSprite: enemies[0])
                }
                dLastShootTime=currentTime
                    
            }
        }
        for enemy in enemies {
            if enemy.position.y < -240 {
                lives = lives - 1
                if lives > 0 {
                    enemies.removeLast()
                    enemy.removeFromParent()
                } else {
                    isPaused = true
                    prepareLabel.text = "Game Over"
                }
                
                
            }
        }
    }

    
    func projectileDidCollideWithEnemy(projectile: Bullet, enemy: Enemy) {
//        print("Hit")
        enemy.hits += 1
        projectile.removeFromParent()
        // ladybugs
        if String(describing: projectile.parentTower.texture!) == "<SKTexture> 'ladybug' (56 x 56)" {
            print("ladybug hit!")
            checkIfKilled(enemy: enemy)
        }
        //grasshoppers
        if String(describing: projectile.parentTower.texture!) == "<SKTexture> 'grasshopper' (77 x 77)" {
            print("grasshopper hit!")
            if enemy.hits > 1 {
                bulletsArray.removeLast()
                enemy.removeFromParent()
                if enemies.first != nil {
                    if let enemyToRemove = enemies.index(of: enemy) {
                        enemies.remove(at: enemyToRemove)
                        seeds = seeds + 1
                    }
                }
            }
        }
        if String(describing: projectile.parentTower.texture!) == "<SKTexture> 'earthworm' (77 x 77)" {
            print("earthworm hit!")
            if enemy.hits > 1 {
                bulletsArray.removeLast()
                enemy.removeFromParent()
                if enemies.first != nil {
                    if let enemyToRemove = enemies.index(of: enemy) {
                        enemies.remove(at: enemyToRemove)
                        seeds = seeds + 1
                    }
                }
            }
        }
        
    }
    
func checkIfKilled(enemy: Enemy) {
        if enemy.strength == 3 {
            if enemy.hits > 5 {
                bulletsArray.removeLast()
                enemy.removeFromParent()
                if enemies.first != nil {
                    if let enemyToRemove = enemies.index(of: enemy) {
                        enemies.remove(at: enemyToRemove)
                        seeds = seeds + 1
                    }
                }
            }
        } else if enemy.strength == 2 {
            if enemy.hits > 1 {
            bulletsArray.removeLast()
            enemy.removeFromParent()
            if enemies.first != nil {
                if let enemyToRemove = enemies.index(of: enemy) {
                    enemies.remove(at: enemyToRemove)
                    seeds = seeds + 1
                }
            }
        }
        } else {
                bulletsArray.removeLast()
                enemy.removeFromParent()
                if enemies.first != nil {
                    if let enemyToRemove = enemies.index(of: enemy) {
                        enemies.remove(at: enemyToRemove)
                        seeds = seeds + 1
                    }
                }
    }
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
            if let enemy = firstBody.node as? Enemy,
                let projectile = secondBody.node as? Bullet {
                projectileDidCollideWithEnemy(projectile: projectile, enemy: enemy)
            }
        }
    }
}
