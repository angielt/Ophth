//
//  StringUtil.swift
//  Opth
//
//  Created by Nancy Fong on 7/26/20.
//  Copyright © 2020 Angie Ta. All rights reserved.
//

import Foundation
import SwiftRichString

extension String {
    func removingExcelSmartQuotes() -> String {
        return self.replacingOccurrences(of: "‘-", with: "-")
    }
}

extension AttributedString {
    func indentLines(by indAmount: CGFloat, originalStr: String) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.firstLineHeadIndent = 0
        paragraph.headIndent = indAmount
        
        let range2 = (self.string as NSString).range(of: originalStr)
        self.addAttributes([NSAttributedString.Key.paragraphStyle: paragraph], range: range2)
    }
}
