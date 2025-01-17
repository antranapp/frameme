//
//  CompositeImage.swift
//  FrameMe
//
//  Created by Josh Luongo on 13/12/2022.
//

import Foundation
import CoreImage
import ImageIO
import CoreGraphics

public class CompositeImage {
    
    /// Don't do content box finding for screenshot positioning.
    private let skipContentBox: Bool
    
    /// Don't clip the screenshot to the device frame.
    private let noClip: Bool
    
    public init(skipContentBox: Bool = false, noClip: Bool = false) {
        self.skipContentBox = skipContentBox
        self.noClip = noClip
    }
    
    /// Create a composite image from a frame and a screenshot.
    ///
    /// - Parameters:
    ///   - frame: Device Frame
    ///   - screenshot: Screenshot
    /// - Returns: Composited Result
    public func create(deviceFrame: CGImage, screenshot: CGImage) -> CGImage? {
        // Start a context
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        // NOTE: use CGImageAlphaInfo.noneSkipFirst here will
        // fix the issue with the transparent background,
        // but we will lose the transparent background completely
        // The background will become black
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        let context = CGContext(
            data: nil,
            width: deviceFrame.width,
            height: deviceFrame.height,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        )
        
        // Should we try and find the screenshot position data?
        let screenshotPosition = skipContentBox ? nil : deviceFrame.findContentBox(ref: CGPoint(x: deviceFrame.width / 2, y: deviceFrame.height / 2))
        
        // Draw screenshot
        if noClip {
            // Don't use the clipping tool.
            context?.draw(
                screenshot,
                in: screenshotPosition ?? CGRect(
                    origin: CGPoint(
                        x: ((deviceFrame.width - screenshot.width) / 2),
                        y: ((deviceFrame.height - screenshot.height) / 2)),
                    size: CGSize(width: screenshot.width, height: screenshot.height)
                )
            )
        } else {
            // Clip the screenshot
            context?.draw(
                self.clipImage(
                    mask: deviceFrame,
                    image: screenshot,
                    frame: screenshotPosition
                )!,
                in: CGRect(
                    origin: CGPoint.zero,
                    size: CGSize(
                        width: deviceFrame.width,
                        height: deviceFrame.height
                    )
                )
            )
        }
        
        // Draw the device frame.
        context?.draw(deviceFrame, in: CGRect(origin: CGPoint.zero, size: CGSize(width: deviceFrame.width, height: deviceFrame.height)))
        
        return context?.makeImage()
    }
    
    /// Clip an image to a mask.
    ///
    /// - Parameters:
    ///   - mask: The mask.
    ///   - image: The image.
    ///   - frame: The frame to use for the screenshot.
    /// - Returns: Clipped image.
    private func clipImage(mask: CGImage, image: CGImage, frame: CGRect? = nil) -> CGImage? {
        // Start a context
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let context = CGContext(
            data: nil,
            width: mask.width,
            height: mask.height,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        )
        
        // Create the outer matte.
        if let mask = mask.createOuterMatte() {
            // Apply the matte
            context?.clip(to: CGRect(x: 0, y: 0, width: mask.width, height: mask.height), mask: mask)
        }
        
        // Draw screenshot.
        context?.draw(image, in: frame ?? CGRect(origin: CGPoint(x: ((mask.width - image.width) / 2), y: ((mask.height - image.height) / 2)), size: CGSize(width: image.width, height: image.height)))
        
        return context?.makeImage()
    }
    
}
