//
//  CustomShapes.swift
//  SnapWake
//
//  Created by Josselin Biot on 08/03/2026.
//

import SwiftUI

// MARK: - Hexagon Shape
struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let centerX = width / 2
        let centerY = height / 2
        let radius = min(width, height) / 2

        for i in 0..<6 {
            let angle = CGFloat(i) * .pi / 3 - .pi / 2
            let x = centerX + radius * cos(angle)
            let y = centerY + radius * sin(angle)

            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        path.closeSubpath()
        return path
    }
}

// MARK: - Flame Shape
struct FlameShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height

        // Start at bottom center
        path.move(to: CGPoint(x: width * 0.5, y: height))

        // Left side of flame
        path.addCurve(
            to: CGPoint(x: width * 0.2, y: height * 0.6),
            control1: CGPoint(x: width * 0.1, y: height * 0.9),
            control2: CGPoint(x: width * 0.1, y: height * 0.7)
        )

        // Left tip
        path.addCurve(
            to: CGPoint(x: width * 0.3, y: height * 0.3),
            control1: CGPoint(x: width * 0.15, y: height * 0.45),
            control2: CGPoint(x: width * 0.2, y: height * 0.35)
        )

        // Top point
        path.addCurve(
            to: CGPoint(x: width * 0.5, y: 0),
            control1: CGPoint(x: width * 0.35, y: height * 0.15),
            control2: CGPoint(x: width * 0.45, y: height * 0.05)
        )

        // Right side top
        path.addCurve(
            to: CGPoint(x: width * 0.7, y: height * 0.3),
            control1: CGPoint(x: width * 0.55, y: height * 0.05),
            control2: CGPoint(x: width * 0.65, y: height * 0.15)
        )

        // Right tip
        path.addCurve(
            to: CGPoint(x: width * 0.8, y: height * 0.6),
            control1: CGPoint(x: width * 0.8, y: height * 0.35),
            control2: CGPoint(x: width * 0.85, y: height * 0.45)
        )

        // Right side bottom
        path.addCurve(
            to: CGPoint(x: width * 0.5, y: height),
            control1: CGPoint(x: width * 0.9, y: height * 0.7),
            control2: CGPoint(x: width * 0.9, y: height * 0.9)
        )

        path.closeSubpath()
        return path
    }
}

// MARK: - Sparkle Shape (4-pointed star)
struct SparkleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        for i in 0..<8 {
            let angle = Double(i) * .pi / 4
            let length = i % 2 == 0 ? radius : radius * 0.4
            let x = center.x + CGFloat(cos(angle)) * length
            let y = center.y + CGFloat(sin(angle)) * length

            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        path.closeSubpath()
        return path
    }
}

// MARK: - Star Shape (5-pointed)
struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let innerRadius = radius * 0.4

        for i in 0..<10 {
            let angle = Double(i) * .pi / 5 - .pi / 2
            let length = i % 2 == 0 ? radius : innerRadius
            let x = center.x + CGFloat(cos(angle)) * length
            let y = center.y + CGFloat(sin(angle)) * length

            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        path.closeSubpath()
        return path
    }
}

// MARK: - Geometric Badge Icon
struct GeometricBadgeIcon: Shape {
    let iconType: String

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height

        // Map icon types to geometric representations
        switch iconType {
        case "star.fill":
            // 5-pointed star
            return StarShape().path(in: rect)

        case "bed.double.fill":
            // Simple bed rectangle with pillow
            path.addRect(CGRect(x: width * 0.1, y: height * 0.4, width: width * 0.8, height: height * 0.4))
            path.addEllipse(in: CGRect(x: width * 0.15, y: height * 0.2, width: width * 0.3, height: width * 0.25))
            return path

        case "bolt.fill":
            // Lightning bolt
            path.move(to: CGPoint(x: width * 0.6, y: 0))
            path.addLine(to: CGPoint(x: width * 0.2, y: height * 0.5))
            path.addLine(to: CGPoint(x: width * 0.5, y: height * 0.5))
            path.addLine(to: CGPoint(x: width * 0.3, y: height))
            path.addLine(to: CGPoint(x: width * 0.7, y: height * 0.45))
            path.addLine(to: CGPoint(x: width * 0.45, y: height * 0.45))
            path.closeSubpath()
            return path

        case "figure.walk":
            // Simple person silhouette (circle head + body)
            path.addEllipse(in: CGRect(x: width * 0.35, y: height * 0.1, width: width * 0.3, height: height * 0.25))
            // Body
            path.move(to: CGPoint(x: width * 0.5, y: height * 0.35))
            path.addLine(to: CGPoint(x: width * 0.3, y: height * 0.6))
            path.move(to: CGPoint(x: width * 0.5, y: height * 0.35))
            path.addLine(to: CGPoint(x: width * 0.7, y: height * 0.6))
            path.move(to: CGPoint(x: width * 0.5, y: height * 0.35))
            path.addLine(to: CGPoint(x: width * 0.5, y: height * 0.65))
            path.addLine(to: CGPoint(x: width * 0.35, y: height * 0.9))
            path.move(to: CGPoint(x: width * 0.5, y: height * 0.65))
            path.addLine(to: CGPoint(x: width * 0.65, y: height * 0.9))
            return path

        case "moon.stars.fill":
            // Crescent moon
            path.addEllipse(in: CGRect(x: width * 0.2, y: height * 0.2, width: width * 0.6, height: height * 0.6))
            let innerCircle = CGRect(x: width * 0.35, y: height * 0.2, width: width * 0.5, height: height * 0.6)
            path.addEllipse(in: innerCircle)
            return path

        case "waveform":
            // Wave pattern
            path.move(to: CGPoint(x: 0, y: height * 0.5))
            for i in 0..<5 {
                let x = width * CGFloat(i) / 4
                let y = i % 2 == 0 ? height * 0.3 : height * 0.7
                path.addLine(to: CGPoint(x: x, y: y))
            }
            return path

        default:
            // Default: simple diamond
            path.move(to: CGPoint(x: width * 0.5, y: 0))
            path.addLine(to: CGPoint(x: width, y: height * 0.5))
            path.addLine(to: CGPoint(x: width * 0.5, y: height))
            path.addLine(to: CGPoint(x: 0, y: height * 0.5))
            path.closeSubpath()
            return path
        }
    }
}
