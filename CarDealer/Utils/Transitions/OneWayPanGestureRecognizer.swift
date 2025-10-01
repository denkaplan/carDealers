//
//  OneWayPanGestureDirection.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 19.02.24.
//

import UIKit

internal class OneWayPanGestureRecognizer: UIPanGestureRecognizer {
	enum Direction {
		case up
		case down
	}

    private var drag: Bool = false
    private var moveX: Int = 0
    private var moveY: Int = 0
    private var direction: Direction = .down

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)

		guard state != .failed, let touch: UITouch = touches.first else { return }

		let nowPoint: CGPoint = touch.location(in: view)
        let prevPoint: CGPoint = touch.previousLocation(in: view)
        moveX += Int(prevPoint.x - nowPoint.x)
        moveY += Int(prevPoint.y - nowPoint.y)

        if !drag {
            if moveY == 0 {
                drag = false
            } else if (direction == .down && moveY > 0) || (direction == .up && moveY < 0) {
                state = .failed
            } else {
                drag = true
            }
        }
    }

    override func reset() {
        super.reset()
        drag = false
        moveX = 0
        moveY = 0
    }
}
