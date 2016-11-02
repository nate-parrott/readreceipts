//
//  ReadReceipt.swift
//  ReadReceipts
//
//  Created by Nate Parrott on 11/1/16.
//  Copyright © 2016 Nate Parrott. All rights reserved.
//

import UIKit
import Messages

class ReadReceipt {
    init(text: String, time: Date, id: String) {
        self.id = id
        let fontSize: CGFloat = 11
        let boldFont = UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightSemibold)
        let lightFont = UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightRegular)
        let color = UIColor(white: 0, alpha: 0.4)
        
        let text = NSAttributedString(string: text, attributes: [NSFontAttributeName: boldFont, NSForegroundColorAttributeName: color]).mutableCopy() as! NSMutableAttributedString
        let datePairs = ["X1": time, "X2": time.addingTimeInterval(60)]
        for (name, aTime) in datePairs {
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            let timeStr = formatter.string(from: aTime)
            let lightStr = NSAttributedString(string: timeStr, attributes: [NSFontAttributeName: lightFont, NSForegroundColorAttributeName: color])
            let range = (text.string as NSString).range(of: name)
            if range.location != NSNotFound {
                text.replaceCharacters(in: range, with: lightStr)
            }
        }
        attributedString = text
    }
    var _stickerURLExists = false
    var url: URL {
        get {
            let docDir: String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
            // print("DocDir: \(docDir)")
            return URL(fileURLWithPath: docDir).appendingPathComponent(id).appendingPathExtension("png")
        }
    }
    let attributedString: NSAttributedString
    let id: String
    var image: UIImage {
        get {
            let size = CGSize(width: 100, height: 86)
            let format = UIGraphicsImageRendererFormat()
            format.opaque = false
            format.scale = 4 // 3?
            let padding: CGFloat = 2
            let marginBottom: CGFloat = 10
            return UIGraphicsImageRenderer(size: size, format: format).image(actions: { (ctx) in
                let maxTextSize = CGSize(width: size.width - padding * 2, height: size.height - padding * 2)
                let textSize = self.attributedString.boundingRect(with: maxTextSize, options: .usesLineFragmentOrigin, context: nil).size
                let textRect = CGRect(x: round((size.width - textSize.width)/2), y: size.height - textSize.height - padding - marginBottom, width: textSize.width, height: textSize.height)
                UIColor.white.setFill()
                UIBezierPath(roundedRect: textRect.insetBy(dx: -padding, dy: -padding), cornerRadius: 5).fill()
                self.attributedString.draw(in: textRect)
            })
        }
    }
    var sticker: MSSticker {
        get {
            if !_stickerURLExists {
                try! UIImagePNGRepresentation(image)?.write(to: url)
                _stickerURLExists = true
            }
            return try! MSSticker(contentsOfFileURL: url, localizedDescription: attributedString.string)
        }
    }
}
