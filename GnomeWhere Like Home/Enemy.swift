//
//  Enemy.swift
//  GnomeWhere Like Home
//
//  Created by Brooke Huntington on 11/27/18.
//  Copyright © 2018 Brooke Huntington. All rights reserved.
//

import Foundation

class Enemy {
    var health: Int
    var speed: Double
    
    init(health: Int, speed: Double) {
        self.health = health
        self.speed = speed
    }
}
