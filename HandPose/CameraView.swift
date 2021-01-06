/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The camera view shows the feed from the camera, and renders the points
     returned from VNDetectHumanHandpose observations.
*/

import UIKit
import AVFoundation

class CameraView: UIView {

    // A layer that draws a cubic Bezier spline in its coordinate space.
    private var overlayLayer = CAShapeLayer()
    // A path that consists of straight and curved line segments that you can render in your custom views.
    private var pointsPath = UIBezierPath()

    // A Core Animation layer that displays the video as it’s captured.
    var previewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }

    // The protocol to which all class types implicitly conform.
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    // A structure that contains the location and dimensions of a rectangle.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupOverlay()
    }
    
    // An abstract class that serves as the basis for objects that enable archiving and distribution of other objects.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupOverlay()
    }
    
    // Tells the layer to update its layout.
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if layer == previewLayer {
            overlayLayer.frame = layer.bounds
        }
    }

    private func setupOverlay() {
        previewLayer.addSublayer(overlayLayer)
    }
    
    func showPoints(_ points: [CGPoint], color: UIColor) {
        pointsPath.removeAllPoints()
        for point in points {
            pointsPath.move(to: point)
            pointsPath.addArc(withCenter: point, radius: 5, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        }
        overlayLayer.fillColor = color.cgColor
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        overlayLayer.path = pointsPath.cgPath
        CATransaction.commit()
    }
}
