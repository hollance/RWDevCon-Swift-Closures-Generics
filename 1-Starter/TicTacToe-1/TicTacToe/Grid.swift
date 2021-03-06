//
//  Grid.swift
//  TicTacToe
//
//  Created by Matthijs on 10-12-14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

struct Grid {
  let columns: Int
  let rows: Int

  private var array: Array<Player?>

  init(columns: Int, rows: Int) {
    self.columns = columns
    self.rows = rows
    self.array = Array<Player?>(count: rows*columns, repeatedValue: nil)
  }

  subscript(position: Position) -> Player? {
    get {
      return array[position.row*columns + position.column]
    }
    set {
      array[position.row*columns + position.column] = newValue
    }
  }

  func countOccupiedSpaces() -> Int {
    var count = 0
    for element in array {
      if element != nil {
        ++count
      }
    }
    return count
  }
}
