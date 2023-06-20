//
//  File.swift
//  
//
//  Created by An Tran on 21/6/23.
//

import Foundation
import AppKit
import CoreGraphics

extension NSImage {
    var cgImageWithTransparency: CGImage? {
        guard let imageData = self.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: imageData) else {
            // Handle error if image conversion fails
            return nil
        }
        
        bitmap.isOpaque = false
        
        return bitmap.cgImage
    }
}

