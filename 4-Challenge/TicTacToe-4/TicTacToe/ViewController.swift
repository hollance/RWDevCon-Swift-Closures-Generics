//
//  ViewController.swift
//  TicTacToe
//
//  Created by Matt Galloway on 15/11/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet var board: Board!

  private var grid = Grid<Player>(columns: 3, rows: 3)

  private let playerX = Player.X(avatar: UIImage(named: "Ray")!)
  private let playerO = Player.O
  private let ai: AI

  private var player: Player

  required init(coder aDecoder: NSCoder) {
    self.player = self.playerX
    self.ai = AI(player: self.playerO, opponent: self.playerX)
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.board.touchHandler = handleTouch
    nextMove()
  }

  private func oppositePlayer() -> Player {
    switch player {
    case .X:
      return playerO
    case .O:
      return playerX
    }
  }

  private func handleTouch(position: Position) {
    println("Pressed \(position.asString())")

    if let player = self.grid[position] {
      println("Play already exists at this position!")
    } else {
      handleMove(position)
    }
  }

  private func handleMove(position: Position) {
    let lastMove = (position: position, player: self.player)

    self.grid[position] = self.player
    self.board.animatePlayer(self.player, atPosition: position)
    self.player = oppositePlayer()
    self.board.setNeedsDisplay()

    if !self.checkEnd(lastMove) {
      nextMove()
    }
  }

  private func nextMove() {
    if self.player == self.ai.player {
      println("AI move")
      self.view.userInteractionEnabled = false

      self.ai.calculateMove(self.grid) {
        position in self.handleMove(position)
      }
    } else {
      println("Human move")
      self.view.userInteractionEnabled = true
    }
  }

  private func reset() {
    self.grid = Grid(columns: 3, rows: 3)
    self.board.animateReset()
    nextMove()
  }

  private func checkEnd(lastMove: (position: Position, player: Player)) -> Bool {
    if checkWin(self.grid, lastMove.position, lastMove.player) {
      println("Winner!")

      var playerString = ""
      switch lastMove.player {
      case .X:
        playerString = "X"
      case .O:
        playerString = "O"
      }

      let alert = UIAlertController(title: "Winner!", message: "\(playerString) has won", preferredStyle: .Alert)
      alert.addAction(UIAlertAction(title: "New Game", style: .Default) {
        _ in self.reset()
      })
      self.presentViewController(alert, animated: true, completion: nil)
      return true
    } else if self.grid.countOccupiedSpaces() == 9 {
      println("Game end - no winner")

      let alert = UIAlertController(title: "Too bad", message: "No winner", preferredStyle: .Alert)
      alert.addAction(UIAlertAction(title: "New Game", style: .Default) {
        _ in self.reset()
        })
      self.presentViewController(alert, animated: true, completion: nil)
      return true
    }
    return false
  }

}

