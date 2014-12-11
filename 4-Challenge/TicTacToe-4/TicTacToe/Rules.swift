//
//  Rules.swift
//  TicTacToe
//
//  Created by Matthijs on 10-12-14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import Foundation

private typealias Step = (i: Int, row: Int, column: Int) -> Position

private let horizontal: Step = { i, row, column in Position(column: i, row: row) }
private let vertical:   Step = { i, row, column in Position(column: column, row: i) }
private let diagonalA:  Step = { i, row, column in Position(column: i, row: i) }
private let diagonalB:  Step = { i, row, column in Position(column: i, row: 2-i) }

private func winInDirection<T: Equatable>(grid: Grid<T>, position: Position, player: T, stepper: Step) -> Bool {
  let row = position.row
  let column = position.column

  var win = true
  for i in 0..<3 {
    if let test = grid[stepper(i: i, row: row, column: column)] {
      if test != player {
        win = false
        break
      }
    } else {
      win = false
      break
    }
  }
  return win
}

func checkWin<T: Equatable>(grid: Grid<T>, position: Position, player: T) -> Bool {
  return winInDirection(grid, position, player, horizontal)
      || winInDirection(grid, position, player, vertical)
      || winInDirection(grid, position, player, diagonalA)
      || winInDirection(grid, position, player, diagonalB)
}
