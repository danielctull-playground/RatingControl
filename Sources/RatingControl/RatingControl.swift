
import SwiftUI

public struct RatingControl<Data, Label>: View
    where
    Data: RandomAccessCollection,
    Data.Element: Equatable,
    Data.Element: CustomStringConvertible,
    Data.Element: Identifiable,
    Label: View
{

    public init(
        data: Data,
        selection: Binding<Data.Element>,
        @ViewBuilder label: () -> Label
    ) {
        self.data = data
        self._selection = selection
        self.label = label()
    }

    private let label: Label
    private let data: Data
    @Binding private var selection: Data.Element

    @State private var number = 0

    public var body: some View {
        VStack(alignment: .leading) {

            label

            Segments(data: data, selection: $selection)
                .frame(height: 10)

            Text(selection.description)
                .font(.callout)
        }
        .accessibilityElement()
        .accessibilityValue(selection.description)
        .accessibilityAdjustableAction { selection = data.adjust(selection, direction: $0) }
    }
}

extension RatingControl {

    public init<Value>(
        selection: Binding<Value>,
        @ViewBuilder label: () -> Label
    )
        where
        Label == Text,
        Value: CaseIterable,
        Value.AllCases == Data
    {
        self.init(data: Value.allCases, selection: selection, label: label)
    }
}

private struct Segments<Data>: View
    where
    Data: RandomAccessCollection,
    Data.Element: Equatable,
    Data.Element: CustomStringConvertible,
    Data.Element: Identifiable
{
    let data: Data
    @Binding var selection: Data.Element

    func index(of element: Data.Element) -> Data.Index {
        data.firstIndex(of: element) ?? data.startIndex
    }

    var body: some View {
        HStack(spacing: 1) {
            ForEach(data) { element in
                Segment(filled: index(of: element) <= index(of: selection))
                    .onTapGesture { selection = element }
            }
        }
        .onDragGesture { selection = data.value(at: $0.x) }
    }
}

private struct Segment: View {
    let filled: Bool
    var body: some View {
        filled ? Color.blue : .gray
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

#if DEBUG

enum Rating: CaseIterable, Comparable {
    case one, two, three, four, five
}

extension Rating: Identifiable {
    var id: Self { self }
}

extension Rating: CustomStringConvertible {
    var description: String {
        switch self {
        case .one: return "One"
        case .two: return "Two"
        case .three: return "Three"
        case .four: return "Four"
        case .five: return "Five"
        }
    }
}

struct ContentView: View {

    @State var selection = Rating.one
    var body: some View {
        RatingControl(selection: $selection) {
            Text("Rating")
                .font(.headline)
        }
        .padding()
    }
}

struct RatingControl_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#endif
