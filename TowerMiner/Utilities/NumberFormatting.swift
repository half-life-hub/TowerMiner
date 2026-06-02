import Foundation

enum NumberFormatting {
    static func compact(_ value: Int) -> String {
        let sign = value < 0 ? "-" : ""
        let magnitude = abs(value)

        switch magnitude {
        case 0..<10_000:
            return "\(value)"
        case 10_000..<999_500:
            return sign + compactDecimal(Double(magnitude) / 1_000) + "K"
        case 999_500..<1_000_000:
            return sign + "1M"
        case 1_000_000..<999_500_000:
            return sign + compactDecimal(Double(magnitude) / 1_000_000) + "M"
        case 999_500_000..<1_000_000_000:
            return sign + "1B"
        default:
            return sign + compactDecimal(Double(magnitude) / 1_000_000_000) + "B"
        }
    }

    static func grouped(_ value: Int) -> String {
        value.formatted(.number.grouping(.automatic))
    }

    private static func compactDecimal(_ value: Double) -> String {
        if value >= 100 {
            return String(format: "%.0f", value)
        }

        if value >= 10 {
            return String(format: "%.1f", value).trimmingTrailingZeroDecimal()
        }

        return String(format: "%.2f", value).trimmingTrailingZeroDecimal()
    }
}

private extension String {
    func trimmingTrailingZeroDecimal() -> String {
        var result = self
        while result.last == "0" {
            result.removeLast()
        }

        if result.last == "." {
            result.removeLast()
        }

        return result
    }
}
