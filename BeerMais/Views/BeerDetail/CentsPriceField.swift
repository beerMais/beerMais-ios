import SwiftUI

/// Applies the cents binding synchronously, keeping displayed text and cursor in sync.
struct CentsPriceField: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFocused: Bool
    let fontSize: CGFloat

    func makeUIView(context: Context) -> UITextField {
        let field = UITextField()
        field.placeholder = "0,00"
        field.keyboardType = .numberPad
        field.accessibilityLabel = "price".localized
        field.adjustsFontSizeToFitWidth = true
        field.minimumFontSize = 24
        field.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        field.delegate = context.coordinator
        field.addTarget(context.coordinator, action: #selector(Coordinator.editingChanged(_:)), for: .editingChanged)
        return field
    }

    func updateUIView(_ field: UITextField, context: Context) {
        context.coordinator.parent = self
        field.font = .systemFont(ofSize: fontSize, weight: .bold)
        if field.text != text { field.text = text }
        if isFocused && !field.isFirstResponder {
            field.becomeFirstResponder()
        } else if !isFocused && field.isFirstResponder {
            field.resignFirstResponder()
        }
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UITextField, context: Context) -> CGSize? {
        let font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        let content = text.isEmpty ? "0,00" : text
        // Fit the amount plus the caret, so the currency/amount group centers as a unit.
        let naturalWidth = ceil((content as NSString).size(withAttributes: [.font: font]).width) + 4
        return CGSize(width: min(proposal.width ?? naturalWidth, naturalWidth), height: proposal.height ?? font.lineHeight)
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    final class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CentsPriceField

        init(_ parent: CentsPriceField) { self.parent = parent }

        @objc func editingChanged(_ field: UITextField) {
            let formatted = BeerDisplay.centsInput(field.text ?? "") ?? parent.text
            parent.text = formatted
            // Binding reads may be cached for this render; display the computed value directly.
            field.text = formatted
            field.selectedTextRange = field.textRange(from: field.endOfDocument, to: field.endOfDocument)
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            if !parent.isFocused { parent.isFocused = true }
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            if parent.isFocused { parent.isFocused = false }
        }
    }
}
