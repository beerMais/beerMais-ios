import SwiftUI

struct BeerView: View {
    @ObservedObject private var viewModel: ViewModel
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @ScaledMetric(relativeTo: .subheadline) private var packageColumnWidth = 54

    init(viewModel: ViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }

    private var container: some View {
        VStack(spacing: 10) {
            let title = Text(viewModel.brand).font(.headline)
            if dynamicTypeSize.isAccessibilitySize {
                title.fixedSize(horizontal: false, vertical: true)
            } else {
                title.lineLimit(1).minimumScaleFactor(0.85)
            }
            let footer = Text(viewModel.isHighlighted ? "disclaimer".localized : viewModel.itemNumber.map(String.init) ?? "")
                .font(.caption2)
                .lineLimit(dynamicTypeSize.isAccessibilitySize ? nil : 1)
                .minimumScaleFactor(0.8)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
            let layout = dynamicTypeSize.isAccessibilitySize
                ? AnyLayout(VStackLayout(spacing: 10))
                : AnyLayout(HStackLayout(alignment: viewModel.isHighlighted ? .center : .bottom, spacing: 10))
            layout {
                VStack(spacing: 4) {
                    viewModel.image
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .accessibilityHidden(true)
                    Text(viewModel.amount)
                        .font(.subheadline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .frame(width: dynamicTypeSize.isAccessibilitySize ? nil : packageColumnWidth)
                VStack(spacing: 6) {
                    Text(viewModel.beerValue)
                        .font(.title3)
                        .monospacedDigit()
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    if !viewModel.isHighlighted {
                        Text(viewModel.beerEconomyValue)
                            .font(.caption)
                            .monospacedDigit()
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                            .foregroundStyle(.secondary)
                        footer
                    }
                }
                .frame(maxWidth: .infinity)
                if viewModel.isHighlighted {
                    VStack(spacing: 4) {
                        Text("saving").font(.subheadline)
                        Text(viewModel.beerEconomyValue)
                            .font(.headline)
                            .monospacedDigit()
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                            .foregroundStyle(Color("economyBorder"))
                        footer
                    }
                    .frame(maxWidth: .infinity)
                }
            }

        }
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
        .padding(12)
        .frame(maxWidth: .infinity)
        .foregroundStyle(Color.primary)
        .background(
            viewModel.isHighlighted && viewModel.beer != nil
                ? Color("economyBackground") : Color(uiColor: .tertiarySystemBackground),
            in: RoundedRectangle(cornerRadius: 16)
        )
        .accessibilityElement(children: .combine)
    }

    var body: some View {
        if #available(iOS 26.0, *) {
            container.glassEffect(.regular, in: .rect(cornerRadius: 16))
        } else {
            container.overlay {
                RoundedRectangle(cornerRadius: 16).stroke(Color("economyBorder"), lineWidth: 1)
            }
        }
    }
}
