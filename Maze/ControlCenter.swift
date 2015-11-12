//
//  ControlCenter.swift
//  Maze
//
//  Created by Jarrod Parkes on 8/14/15.
//  Copyright © 2015 Udacity, Inc. All rights reserved.
//
import UIKit

class ControlCenter {
  
  var mazeController: MazeController!
  
  func moveComplexRobot(myRobot: ComplexRobotObject) {
    
    let robotIsBlocked = isFacingWall(myRobot, direction: myRobot.direction)
    let myWallInfo = checkWalls(myRobot)
    let isThreeWayJunction = (myWallInfo.numberOfWalls == 1)
    let isTwoWayPath = (myWallInfo.numberOfWalls == 2)
    let isDeadEnd = (myWallInfo.numberOfWalls == 3)
    
    if isThreeWayJunction && robotIsBlocked {
      randomlyRotateRightOrLeft(myRobot)
    } else if isThreeWayJunction && !robotIsBlocked{
      continueStraightOrRotate(myRobot, wallInfo: myWallInfo)
    } else if isTwoWayPath && robotIsBlocked {
      turnTowardClearPath(myRobot, wallInfo: myWallInfo)
    } else if isTwoWayPath && !robotIsBlocked{
      myRobot.move()
    } else if isDeadEnd {
      if robotIsBlocked{
        myRobot.rotateRight()
      } else {
        myRobot.move()
      }
    }
  }
  
  func isFacingWall(robot: ComplexRobotObject, direction: MazeDirection) -> Bool {
    
    let cell = mazeController.currentCell(robot)
    var isWall: Bool = false
    switch(direction) {
    case .Up:
      if cell.top {
        isWall = true
      }
    case .Right:
      if cell.right{
        isWall = true
      }
    case .Down:
      if cell.bottom{
        isWall = true
      }
    case .Left:
      if cell.left{
        isWall = true
      }
    }
    return isWall
  }
  
  func checkWalls(robot:ComplexRobotObject) -> (up: Bool, right: Bool, down: Bool, left: Bool, numberOfWalls: Int) {
    
    var numberOfWalls = 0
    let cell = mazeController.currentCell(robot)

    let isWallUp = cell.top
    if isWallUp {
      numberOfWalls++
    }
    let isWallRight = cell.right
    if isWallRight {
      numberOfWalls++
    }
    let isWallBottom = cell.bottom
    if isWallBottom {
      numberOfWalls++
    }
    let isWallLeft = cell.left
    if isWallLeft {
      numberOfWalls++
    }
    
    return (isWallUp, isWallRight, isWallBottom, isWallLeft, numberOfWalls)
  }
  
  func randomlyRotateRightOrLeft(robot: ComplexRobotObject) {
    
    let randomNumber = arc4random() % 2
    if randomNumber == 0 {
      robot.rotateLeft()
    } else {
      robot.rotateRight()
    }
  }
  
  func continueStraightOrRotate(robot: ComplexRobotObject, wallInfo: (up: Bool, right: Bool, down: Bool, left: Bool, numberOfWalls: Int) ) {
    let randomNumber = arc4random() % 2
    if randomNumber == 1 {
      robot.move()
    } else {
      turnTowardClearPath(robot, wallInfo: wallInfo)
    }
  }
  
  func turnTowardClearPath(robot: ComplexRobotObject, wallInfo: (up: Bool, right: Bool, down: Bool, left: Bool, numberOfWalls: Int)) {
    
    if robot.direction == .Left && wallInfo.down {
      robot.rotateRight()
    } else if robot.direction == .Up && wallInfo.left {
      robot.rotateRight()
    } else if robot.direction == .Right && wallInfo.up{
      robot.rotateRight()
    } else if robot.direction == .Down && wallInfo.right{
      robot.rotateRight()
    } else {
      robot.rotateLeft()
    }
  }
  
  func previousMoveIsFinished(robot: ComplexRobotObject) {
    self.moveComplexRobot(robot)
  }
  
}