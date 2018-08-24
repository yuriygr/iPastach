//
//  UILabel.swift
//  iPastach
//
//  Created by Юрий Гринев on 10.08.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

extension UILabel {
    
    func addImageWith(name: String, color: UIColor, behindText: Bool) {
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: name)?
            .resize(to: CGSize(width: self.font.pointSize, height: self.font.pointSize))?
            .color(to: color)
        attachment.bounds = CGRect(x: 0, y: -1.5, width: attachment.image!.size.width, height: attachment.image!.size.height)
        
        let attachmentString = NSAttributedString(attachment: attachment)
        
        guard let txt = self.text else {
            return
        }
        
        if behindText {
            let strLabelText = NSMutableAttributedString(string: txt)
            strLabelText.append(attachmentString)
            self.attributedText = strLabelText
        } else {
            let strLabelText = NSAttributedString(string: txt)
            let mutableAttachmentString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            self.attributedText = mutableAttachmentString
        }
    }
    
    func removeImage() {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }

    func setHtmlText(_ html: String) {
        if let attributedText = html.attributedHtmlString {
            self.attributedText = attributedText
        }
    }
}
