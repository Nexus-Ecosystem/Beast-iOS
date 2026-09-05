import SwiftUI

struct BikeSelectionView: View {
    let context: BikeSelectionContext

    @ObservedObject var viewModel: BikeSelectionViewModel

    private let cellSize: CGFloat = 64

    private let purple = Color(
        red: 0.46,
        green: 0.27,
        blue: 1.0
    )

    private let availableColor = Color(
        red: 0.64,
        green: 0.90,
        blue: 0.21
    )

    private let myBikeColor = Color(
        red: 1.0,
        green: 0.67,
        blue: 0.25
    )

    private let occupiedColor = Color(
        red: 0.44,
        green: 0.44,
        blue: 0.48
    )

    private let maintenanceColor = Color(
        red: 0.98,
        green: 0.44,
        blue: 0.52
    )

    private let furnitureColor = Color(
        red: 0.46,
        green: 0.27,
        blue: 1.0
    )

    var body: some View {
        ZStack {
            Color("BeastBackground")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                classSummary
                    .padding(.top, 8)

                legends
                    .padding(.top, 14)

                studioCanvas
                    .padding(.top, 12)
            }
            .padding(.horizontal, 16)

            if viewModel.isLoading {
                BeastLoadingOverlay(
                    message: "Actualizando bicicletas..."
                )
                .zIndex(100)
            }

            if let bike = viewModel.selectedBike {
                bikeConfirmation(
                    bike
                )
                .zIndex(200)
            }

            if viewModel.showSuccess {
                BeastAlertDialog(
                    style: .success,
                    title: "¡Listo!",
                    message: viewModel.message,
                    buttonTitle: "Entendido"
                ) {
                    viewModel.closeSuccess()
                }
                .zIndex(300)
            }

            if viewModel.showError {
                BeastAlertDialog(
                    style: .error,
                    title: "¡Atención!",
                    message: viewModel.message,
                    buttonTitle: "Entendido"
                ) {
                    viewModel.closeError()
                }
                .zIndex(300)
            }
        }
        .navigationTitle("Selección de Bici")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(
                placement: .topBarTrailing
            ) {
                Image(
                    systemName: "bolt.fill"
                )
                .font(
                    .system(
                        size: 16,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    purple
                )
            }
        }
        .onAppear {
            viewModel.load(
                context: context
            )
        }
    }

    private var classSummary: some View {
        HStack(
            spacing: 14
        ) {
            coachImage

            VStack(
                alignment: .leading,
                spacing: 5
            ) {
                Text(
                    context.classItem.name.isEmpty
                    ? "Clase de Spinning"
                    : context.classItem.name
                )
                .font(
                    .system(
                        size: 16,
                        weight: .black
                    )
                )
                .foregroundStyle(
                    .primary
                )

                Text(
                    "Coach: \(context.classItem.coach.isEmpty ? "Instructor" : context.classItem.coach)"
                )
                .font(
                    .system(
                        size: 11,
                        weight: .medium
                    )
                )
                .foregroundStyle(
                    .secondary
                )

                Text(
                    "Horario: \(context.classItem.time) (\(context.classItem.duration) min)"
                )
                .font(
                    .system(
                        size: 10,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    purple
                )
            }

            Spacer()
        }
        .padding(16)
        .frame(
            maxWidth: .infinity
        )
        .background(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
            .fill(
                Color(
                    .secondarySystemBackground
                )
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
            .stroke(
                Color.primary.opacity(
                    0.75
                ),
                lineWidth: 1
            )
        )
    }

    private var coachImage: some View {
        Group {
            if
                !context.classItem.photo.isEmpty,
                let url = URL(
                    string: context.classItem.photo
                )
            {
                AsyncImage(
                    url: url
                ) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    coachInitials
                }
            } else {
                coachInitials
            }
        }
        .frame(
            width: 50,
            height: 50
        )
        .clipShape(
            Circle()
        )
    }

    private var coachInitials: some View {
        ZStack {
            Circle()
                .fill(
                    Color(
                        red: 0.12,
                        green: 0.12,
                        blue: 0.14
                    )
                )

            Text(
                initials(
                    context.classItem.coach
                )
            )
            .font(
                .system(
                    size: 12,
                    weight: .bold
                )
            )
            .foregroundStyle(
                .white
            )
        }
    }

    private var legends: some View {
        HStack(
            spacing: 0
        ) {
            legend(
                color: availableColor,
                title: "Disponible"
            )

            Spacer()

            legend(
                color: myBikeColor,
                title: "Tu Bici"
            )

            Spacer()

            legend(
                color: occupiedColor,
                title: "Ocupada"
            )

            Spacer()

            legend(
                color: maintenanceColor,
                title: "Descompuesta"
            )
        }
        .padding(
            .horizontal,
            4
        )
    }

    private func legend(
        color: Color,
        title: String
    ) -> some View {
        HStack(
            spacing: 5
        ) {
            Circle()
                .fill(
                    color
                )
                .frame(
                    width: 8,
                    height: 8
                )

            Text(
                title
            )
            .font(
                .system(
                    size: 8,
                    weight: .medium
                )
            )
            .foregroundStyle(
                .secondary
            )
            .fixedSize()
        }
    }

    private var studioCanvas: some View {
        GeometryReader { proxy in
            ScrollView(
                [.horizontal, .vertical],
                showsIndicators: false
            ) {
                ZStack(
                    alignment: .topLeading
                ) {
                    RoundedRectangle(
                        cornerRadius: 24,
                        style: .continuous
                    )
                    .fill(
                        Color(
                            .secondarySystemBackground
                        )
                    )
                    .frame(
                        width: max(
                            canvasWidth,
                            proxy.size.width
                        ),
                        height: max(
                            canvasHeight,
                            proxy.size.height
                        )
                    )

                    ForEach(
                        Array(
                            elements.enumerated()
                        ),
                        id: \.offset
                    ) { _, element in
                        studioElement(
                            element
                        )
                        .frame(
                            width:
                                cellSize - 12,
                            height:
                                cellSize - 12
                        )
                        .offset(
                            x:
                                CGFloat(
                                    element.gridX
                                ) *
                                cellSize + 6,
                            y:
                                CGFloat(
                                    element.gridY
                                ) *
                                cellSize + 6
                        )
                    }
                }
                .frame(
                    width: max(
                        canvasWidth,
                        proxy.size.width
                    ),
                    height: max(
                        canvasHeight,
                        proxy.size.height
                    ),
                    alignment: .topLeading
                )
            }
            .defaultScrollAnchor(
                .topLeading
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 24,
                    style: .continuous
                )
            )
            .overlay {
                RoundedRectangle(
                    cornerRadius: 24,
                    style: .continuous
                )
                .stroke(
                    Color.primary.opacity(
                        0.04
                    ),
                    lineWidth: 1
                )
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .padding(
            .bottom,
            12
        )
    }

    private var elements: [StudioElementModel] {
        viewModel.stage?.myBikes ?? []
    }

    private var dynamicColumns: Int {
        if elements.isEmpty {
            return max(
                viewModel.stage?
                    .gridConfig?
                    .cols ?? 10,
                1
            )
        }

        let maxX = elements
            .map(\.gridX)
            .max() ?? 0

        return max(
            maxX + 1,
            1
        )
    }

    private var dynamicRows: Int {
        if elements.isEmpty {
            return max(
                viewModel.stage?
                    .gridConfig?
                    .rows ?? 4,
                1
            )
        }

        let maxY = elements
            .map(\.gridY)
            .max() ?? 0

        return max(
            maxY + 1,
            1
        )
    }

    private var canvasWidth: CGFloat {
        CGFloat(
            dynamicColumns
        ) *
        cellSize + 24
    }

    private var canvasHeight: CGFloat {
        CGFloat(
            dynamicRows
        ) *
        cellSize + 24
    }

    @ViewBuilder
    private func studioElement(
        _ element: StudioElementModel
    ) -> some View {
        let style = elementStyle(
            element
        )

        let isBike =
            element.type.lowercased() ==
            "bike"

        Button {
            if isBike {
                viewModel.select(
                    element
                )
            }
        } label: {
            ZStack {
                RoundedRectangle(
                    cornerRadius: 14,
                    style: .continuous
                )
                .fill(
                    style.background
                )

                RoundedRectangle(
                    cornerRadius: 14,
                    style: .continuous
                )
                .stroke(
                    style.border,
                    lineWidth: 1.25
                )

                if isBike {
                    VStack(
                        spacing: 2
                    ) {
                        Image(
                            systemName:
                                "bicycle"
                        )
                        .font(
                            .system(
                                size: 17,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(
                            style.foreground
                        )

                        Text(
                            element.label
                        )
                        .font(
                            .system(
                                size: 9,
                                weight: .black
                            )
                        )
                        .foregroundStyle(
                            .primary
                        )
                    }
                } else {
                    Text(
                        element.label.uppercased()
                    )
                    .font(
                        .system(
                            size: 7,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        style.foreground
                    )
                    .lineLimit(1)
                    .minimumScaleFactor(
                        0.4
                    )
                    .padding(
                        .horizontal,
                        2
                    )
                }
            }
        }
        .buttonStyle(
            .plain
        )
        .disabled(
            isBike &&
            !viewModel.isSelectable(
                element
            )
        )
        .allowsHitTesting(
            isBike
        )
    }

    private func elementStyle(
        _ element: StudioElementModel
    ) -> (
        background: Color,
        border: Color,
        foreground: Color
    ) {
        let isBike =
            element.type.lowercased() ==
            "bike"

        if !isBike {
            return (
                furnitureColor.opacity(
                    0.12
                ),
                furnitureColor,
                furnitureColor
            )
        }

        if element.status.lowercased() ==
            "maintenance"
        {
            return (
                maintenanceColor.opacity(
                    0.15
                ),
                maintenanceColor,
                maintenanceColor
            )
        }

        if viewModel.isMyBike(
            element
        ) {
            return (
                myBikeColor.opacity(
                    0.20
                ),
                myBikeColor,
                myBikeColor
            )
        }

        if viewModel.isOccupied(
            element
        ) {
            return (
                occupiedColor.opacity(
                    0.15
                ),
                occupiedColor,
                occupiedColor
            )
        }

        return (
            availableColor.opacity(
                0.15
            ),
            availableColor,
            availableColor
        )
    }

    private func bikeConfirmation(
        _ bike: StudioElementModel
    ) -> some View {
        let isMine =
            viewModel.isMyBike(
                bike
            )

        let owner =
            viewModel.assignment(
                for: bike
            )

        let status: String
        let statusColor: Color

        if bike.status.lowercased() ==
            "maintenance"
        {
            status =
                "Descompuesta"

            statusColor =
                maintenanceColor

        } else if isMine {
            status =
                "Reservada por ti"

            statusColor =
                myBikeColor

        } else if owner != nil {
            status =
                "Ocupada"

            statusColor =
                occupiedColor

        } else {
            status =
                "Disponible"

            statusColor =
                availableColor
        }

        return ZStack {
            Color.black
                .opacity(
                    0.70
                )
                .ignoresSafeArea()

            VStack(
                alignment: .leading,
                spacing: 16
            ) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(
                                statusColor.opacity(
                                    0.15
                                )
                            )
                            .frame(
                                width: 44,
                                height: 44
                            )

                        Image(
                            systemName:
                                "bicycle"
                        )
                        .font(
                            .system(
                                size: 20,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(
                            statusColor
                        )
                    }

                    VStack(
                        alignment: .leading,
                        spacing: 3
                    ) {
                        Text(
                            "Bicicleta \(bike.label)"
                        )
                        .font(
                            .system(
                                size: 18,
                                weight: .black
                            )
                        )

                        Text(
                            isMine
                            ? "Ya tienes esta bicicleta seleccionada."
                            : "¿Deseas elegir esta bici?"
                        )
                        .font(
                            .system(
                                size: 11
                            )
                        )
                        .foregroundStyle(
                            .secondary
                        )
                    }

                    Spacer()
                }

                HStack(
                    spacing: 6
                ) {
                    Text(
                        "Estatus actual:"
                    )
                    .font(
                        .system(
                            size: 11
                        )
                    )
                    .foregroundStyle(
                        .secondary
                    )

                    Text(
                        status
                    )
                    .font(
                        .system(
                            size: 10,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        statusColor
                    )
                    .padding(
                        .horizontal,
                        8
                    )
                    .padding(
                        .vertical,
                        4
                    )
                    .background(
                        RoundedRectangle(
                            cornerRadius: 8
                        )
                        .fill(
                            statusColor.opacity(
                                0.15
                            )
                        )
                    )
                    .overlay(
                        RoundedRectangle(
                            cornerRadius: 8
                        )
                        .stroke(
                            statusColor,
                            lineWidth: 1
                        )
                    )
                }

                if
                    bike.status.lowercased() ==
                    "active",
                    owner == nil
                {
                    Button {
                        viewModel.confirmBike(
                            context: context
                        )
                    } label: {
                        Text(
                            "Confirmar"
                        )
                        .font(
                            .system(
                                size: 12,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(
                            .white
                        )
                        .frame(
                            maxWidth:
                                .infinity
                        )
                        .frame(
                            height: 44
                        )
                        .background(
                            Capsule()
                                .fill(
                                    purple
                                )
                        )
                    }
                    .buttonStyle(
                        .plain
                    )
                }

                Button {
                    viewModel
                        .closeBikeConfirmation()
                } label: {
                    Text(
                        "Cancelar"
                    )
                    .font(
                        .system(
                            size: 12,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        .secondary
                    )
                    .frame(
                        maxWidth: .infinity
                    )
                    .frame(
                        height: 40
                    )
                }
                .buttonStyle(
                    .plain
                )
            }
            .padding(22)
            .frame(
                maxWidth: 310
            )
            .background(
                RoundedRectangle(
                    cornerRadius: 24,
                    style: .continuous
                )
                .fill(
                    Color(
                        .systemBackground
                    )
                )
            )
        }
    }

    private func initials(
        _ value: String
    ) -> String {
        String(
            value
                .split(
                    separator: " "
                )
                .prefix(2)
                .compactMap {
                    $0.first
                }
        )
        .uppercased()
    }
}
