//
//  AI.swift
//  TicTacToe
//
//  Created by Matthijs on 10-12-14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import Foundation

class AI {
  let player: Player
  let opponent: Player

  init(player: Player, opponent: Player) {
    self.player = player
    self.opponent = opponent
  }

  private var grid = Grid<Player>(columns: 3, rows: 3)
  private var openPositions = [Position]()

  private func detectOpenPositions() {
    openPositions = [Position]()
    for j in 0..<grid.rows {
      for i in 0..<grid.columns {
        let position = Position(column: i, row: j)
        if grid[position] == nil {
          openPositions.append(position)
        }
      }
    }
  }

  func calculateMove(grid: Grid<Player>, completion: (Position) -> ()) {
    self.grid = grid
    detectOpenPositions()

    afterDelay(1.0) {
      let aiPosition = self.tryToWin() ?? self.tryToBlockOpponent() ?? self.openPositions.randomElement()
      completion(aiPosition)
    }
  }

  private func tryAllPositions(player: Player) -> Position? {
    for position in openPositions {
      var newGrid = grid // make copy
      newGrid[position] = player
      if checkWin(newGrid, position, player) {
        return position
      }
    }
    return nil
  }

  private func tryToWin() -> Position? {
    return tryAllPositions(self.player)
  }

  private func tryToBlockOpponent() -> Position? {
    return tryAllPositions(self.opponent)
  }
}
