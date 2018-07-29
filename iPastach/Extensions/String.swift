//
//  String.swift
//  iPastach
//
//  Created by Юрий Гринев on 27.03.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

extension String {
    var utfData: Data? {
        return self.data(using: .utf8)
    }
    var attributedHtmlString: NSAttributedString? {
        guard let data = self.utfData else {
            return nil
        }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)
        ]
        do {
            return try NSAttributedString(data: data, options: options, documentAttributes: nil)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// For easy translate strings
    func translated(with comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
