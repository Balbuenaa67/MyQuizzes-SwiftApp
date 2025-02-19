import Foundation

infix operator =+-= : ComparisonPrecedence

extension String {
    
    func lowerTrimCompare(s: String) -> Bool{
        self.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) ==
            s.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }

    static func =+-= (lhs: String, rhs: String) -> Bool {
        lhs.lowerTrimCompare(s: rhs)
    }
}
