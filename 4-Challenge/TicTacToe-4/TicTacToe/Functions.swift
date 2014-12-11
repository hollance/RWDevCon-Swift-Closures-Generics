import Dispatch

func afterDelay(seconds: Double, perform closure: () -> ()) {
  let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
  dispatch_after(when, dispatch_get_main_queue(), closure)
}

extension Array {
  func randomElement() -> Element {
    let randomIndex = Int(arc4random_uniform(UInt32(self.count)))
    return self[randomIndex]
  }
}
