//
//  Board.swift
//  TicTacToe
//
//  Created by Matt Galloway on 15/11/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import UIKit

class Board: UIView {

  typealias TouchHandler = (Position) -> Void

  var touchHandler: TouchHandler?

  private var cellWidth: CGFloat {
    return CGRectGetWidth(self.bounds) / 3.0
  }

  private var cellHeight: CGFloat {
    return CGRectGetHeight(self.bounds) / 3.0
  }

  override func drawRect(rect: CGRect) {
    let width = CGRectGetWidth(self.bounds)
    let height = CGRectGetHeight(self.bounds)

    // Draw background
    UIColor.whiteColor().setFill()
    UIRectFill(self.bounds)

    // Draw lines
    UIColor.blackColor().setFill()
    UIRectFill(CGRectMake(self.cellWidth, 0, 1, height))
    UIRectFill(CGRectMake(self.cellWidth * 2, 0, 1, height))
    UIRectFill(CGRectMake(0, self.cellHeight, width, 1))
    UIRectFill(CGRectMake(0, self.cellHeight * 2, width, 1))
  }

  func animatePlayer(player: Player, atPosition position: Position) {
    var image: UIImage
    switch player {
    case .X(let avatar):
      image = avatar
    case .O:
      image = UIImage(named: "O")!
    }

    let point = CGPointMake(
      (CGFloat(position.column) + 0.5) * self.cellWidth,
      (CGFloat(position.row) + 0.5) * self.cellHeight)

    let imageView = UIImageView(image: image)
    self.addSubview(imageView)

    imageView.center = point
    imageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(
      CGFloat(M_PI)), 2, 2)

    UIView.animateWithDuration(1,
      delay: 0,
      usingSpringWithDamping: 0.5,
      initialSpringVelocity: 0,
      options: UIViewAnimationOptions(0),
      animations: {
        imageView.transform = CGAffineTransformIdentity
      },
      completion: nil)
  }

  func animateReset() {
    (subviews as NSArray).enumerateObjectsUsingBlock({ obj, index, _ in
      let imageView = obj as UIImageView
      let delay = NSTimeInterval(index) * 0.05

      let anim = { imageView.alpha = 0 }
      let compl = { (finished: Bool) -> Void in imageView.removeFromSuperview() }

      UIView.animateWithDuration(0.2,
        delay: delay,
        options: UIViewAnimationOptions.CurveEaseOut,
        animations: anim,
        completion: compl)
    })
  }

  override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
    let width = CGRectGetWidth(self.bounds)
    let eachWidth = width / 3.0

    let height = CGRectGetHeight(self.bounds)
    let eachHeight = height / 3.0

    for touch in touches {
      let touch = touch as UITouch

      let position = touch.locationInView(self)
      let col = Int(floor(position.x / eachWidth))
      let row = Int(floor(position.y / eachHeight))
      self.touchHandler?(Position(column: col, row: row))
    }
  }

}
