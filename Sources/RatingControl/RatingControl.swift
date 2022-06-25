
import SwiftUI

public struct RatingControl<Value>: View
    where
    Value: CaseIterable,
    Value.AllCases: RandomAccessCollection,
    Value: Comparable,
    Value: CustomStringConvertible,
    Value: Identifiable
{

    public init(title: String, value: Binding<Value>) {
        self.title = title
        self._value = value
    }

    private let title: String
    @Binding private var value: Value

    public var body: some View {
        VStack(alignment: .leading) {

            Text(title)
                .font(.headline)

            Segments(value: $value)
                .frame(height: 10)

            Text(value.description)
                .font(.callout)
        }
        .accessibilityElement()
        .accessibilityLabel(title)
        .accessibilityValue(value.description)
        .accessibilityAdjustableAction { value = Value.allCases.adjust(value, direction: $0) }
    }
}

extension RatingControl {

    private struct Segments: View {
        @Binding var value: Value

        var body: some View {
            HStack(spacing: 1) {
                ForEach(Value.allCases) { value in
                    Segment(filled: value <= self.value)
                        .onTapGesture { self.value = value }
                }
            }
            .onDragGesture { value = Value.allCases.value(at: $0.x) }
        }
    }

    private struct Segment: View {
        let filled: Bool
        var body: some View {
            filled ? Color.blue : .gray
        }
    }
}

extension View {

    fileprivate func onDragGesture(
        _ f: @escaping (CGPoint) -> ()
    ) -> some View {
        GeometryReader { geometry in
            gesture(DragGesture().onChanged { drag in
                let x = drag.location.x / geometry.size.width
                let y = drag.location.y / geometry.size.height
                f(CGPoint(x: x, y: y))
            })
        }
    }
}

extension RandomAccessCollection where Element: Equatable {

    fileprivate func adjust(
        _ element: Element,
        direction: AccessibilityAdjustmentDirection
    ) -> Element {
        guard let index = firstIndex(of: element) else { return element }
        return self[adjust(index, direction: direction)]
    }
}

extension RandomAccessCollection {

    fileprivate func adjust(
        _ index: Index,
        direction: AccessibilityAdjustmentDirection
    ) -> Index {
        guard count > 1 else { return index }
        switch direction {
        case .increment:
            guard index < self.index(before: endIndex) else { return index }
            return self.index(after: index)
        case .decrement:
            guard index > startIndex else { return index }
            return self.index(before: index)
        @unknown default:
            return index
        }
    }

    fileprivate func value(at percentage: CGFloat) -> Element {
        let offset = Int(floor(CGFloat(count) * percentage))
        let limitedOffset = Swift.max(0, Swift.min(count - 1, offset))
        return self[index(startIndex, offsetBy: limitedOffset)]
    }
}
