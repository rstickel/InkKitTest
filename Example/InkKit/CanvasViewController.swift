/*
  Copyright © 13/05/2016 Shaps

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
 */

import UIKit
import InkKit

final class CanvasView: UIView {

  override func draw(_ dirtyRect: CGRect) {
    super.draw(dirtyRect)
    
    let bgFrame = dirtyRect
    
    guard let context = CGContext.current else { return }
    
    context.fill(rect: bgFrame, color: Color(hex: "1c3d64")!)
    
    drawLinesTest()
    
  }
  
  func drawLinesTest() {
    
    drawLineFromPoint(CGPoint(x: 20.0, y: 20.0), toPoint: CGPoint(x: self.frame.size.width-20, y: 150.0), ofColor: Color.white)
    
    drawLineFromPoint(CGPoint(x: self.frame.size.width-20, y: 150.0), toPoint: CGPoint(x: 20.0, y: 350.0), ofColor: Color.orange)
    
    drawLineFromPoint(CGPoint(x: 20.0, y: 350.0), toPoint: CGPoint(x: self.frame.size.width-20, y: self.frame.size.height-20), ofColor: Color.green)
    
  }
  
  func drawLineFromPoint(_ start : CGPoint, toPoint end:CGPoint, ofColor lineColor: Color) {
    
    //design the path
    let path = UIBezierPath()
    path.move(to: start)
    path.addLine(to: end)
    
    guard let context = CGContext.current else { return }
    
    //context.stroke(border: .center, path: path, color: Color(hex: "ffffff")!, thickness: 4)
    context.stroke(path: path, startColor: lineColor, endColor: Color(white: 1.0, alpha: 0.05), angleInDegrees: 90)
    context.draw(shadow: .inner, path: path, color: Color(white: 1, alpha: 0.3), radius: 20, offset: CGSize(width: 0, height: 0))
  }
  
  func drawInnerGrid(in bounds: CGRect) {
    let grid = Grid(colCount: 3, rowCount: 3, bounds: bounds)
    let path = grid.path(include: [ .outline, .columns, .rows ])
    
    Color.white.setStroke()
    path.stroke()
  }
  
  func drawCell(in bounds: CGRect, title: String, includeBorder: Bool = false, includeShadow: Bool = false) {
    guard let context = CGContext.current else { return }
    let path = BezierPath(roundedRect: bounds, cornerRadius: 4)
    
    context.fill(path: path, color: Color(hex: "ff0083")!.with(alpha: 0.3))
    
    if includeShadow {
      context.draw(shadow: .inner, path: path, color: Color(white: 0, alpha: 0.3), radius: 20, offset: CGSize(width: 0, height: 5))
    }
    
    if includeBorder {
      context.stroke(border: .inner, path: path, color: Color(hex: "ff0083")!, thickness: 2)
    }
    
    title.drawAligned(to: bounds, attributes: [
      NSForegroundColorAttributeName: Color.white.uiColor,
      NSFontAttributeName: Font(name: "Avenir-Medium", size: 15)!
      ])
  }
  
  func backIndicatorImage() -> Image {
    return Image.draw(width: 12, height: 22, attributes: nil, drawing: { (context, rect, attributes) in
      attributes.lineWidth = 2
      attributes.strokeColor = Color.white
      
      let bezierPath = BezierPath()
      bezierPath.move(to: CGPoint(x: rect.maxX, y: rect.minY))
      bezierPath.addLine(to: CGPoint(x: rect.maxX - 10, y: rect.midY))
      bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
      attributes.apply(to: bezierPath)
      bezierPath.stroke()
    })
  }
  
}

final class CanvasViewController: UIViewController {
  
  @IBOutlet var canvasView: CanvasView!
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    //animate()
  }
  
  @IBAction func valueChanged(_ slider: UISlider) {
    canvasView.setNeedsDisplay()
  }
  
}
