import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss)
    private var dismiss

    @Environment(\.colorScheme)
    private var colorScheme

    @StateObject private var viewModel =
        EditProfileViewModel()

    @State private var selectedPhoto:
        PhotosPickerItem?

    var body: some View {
        ZStack {
            BeastColors.background
                .ignoresSafeArea()

            ScrollView(
                showsIndicators: false
            ) {
                VStack(
                    spacing: 0
                ) {
                    profileImage

                    Text(
                        viewModel.fullName
                    )
                    .font(
                        .system(
                            size: 22,
                            weight: .black
                        )
                    )
                    .italic()
                    .foregroundStyle(
                        BeastColors.textPrimary
                    )
                    .padding(
                        .top,
                        14
                    )

                    if !viewModel.memberId.isEmpty {
                        Text(
                            "Número de Socio: \(viewModel.memberId)"
                        )
                        .font(
                            .system(
                                size: 10,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(
                            BeastColors.textSecondary
                        )
                        .padding(
                            .top,
                            4
                        )
                    }

                    EditProfileField(
                        title: "NOMBRE COMPLETO",
                        text:
                            $viewModel.fullName
                    )
                    .padding(
                        .top,
                        32
                    )

                    EditProfileField(
                        title: "TELÉFONO",
                        text:
                            $viewModel.phone,
                        keyboardType:
                            .phonePad
                    )
                    .padding(
                        .top,
                        22
                    )

                    EditProfileLockedField(
                        title: "CORREO",
                        value:
                            viewModel.email,
                        helper:
                            "Para cambiar tu correo contacta a administración de tu STUDIO."
                    )
                    .padding(
                        .top,
                        22
                    )

                    HStack(
                        spacing: 14
                    ) {
                        if !viewModel.packageName.isEmpty {
                            EditProfileInfoCard(
                                title:
                                    "Paquete o Suscripción",
                                value:
                                    viewModel.packageName,
                                color:
                                    packageCardColor
                            )
                        }

                        if !viewModel.createdAt.isEmpty {
                            EditProfileInfoCard(
                                title:
                                    "Inicio de registro:",
                                value:
                                    formattedCreatedAt,
                                color:
                                    registrationCardColor
                            )
                        }
                    }
                    .padding(
                        .top,
                        30
                    )

                    Button {
                        Task {
                            await viewModel.save()
                        }
                    } label: {
                        Text(
                            "GUARDAR CAMBIOS"
                        )
                        .font(
                            .system(
                                size: 12,
                                weight: .black
                            )
                        )
                        .foregroundStyle(
                            BeastColors.buttonText
                        )
                        .frame(
                            maxWidth: .infinity
                        )
                        .frame(
                            height: 50
                        )
                        .background(
                            Capsule()
                                .fill(
                                    viewModel.canSave
                                    ? BeastColors.primary
                                    : BeastColors.border
                                )
                        )
                    }
                    .buttonStyle(
                        .plain
                    )
                    .disabled(
                        !viewModel.canSave ||
                        viewModel.isLoading
                    )
                    .padding(
                        .top,
                        38
                    )

                    Spacer()
                        .frame(
                            height: 40
                        )
                }
                .padding(
                    .horizontal,
                    24
                )
            }

            if viewModel.isLoading {
                BeastLoadingOverlay(
                    message:
                        "Guardando cambios..."
                )
                .zIndex(100)
            }

            if viewModel.showSuccess {
                BeastAlertDialog(
                    style: .success,
                    title: "¡Listo!",
                    message:
                        viewModel.message,
                    buttonTitle:
                        "Entendido"
                ) {
                    viewModel.closeSuccess()
                    dismiss()
                }
                .zIndex(200)
            }

            if viewModel.showError {
                BeastAlertDialog(
                    style: .error,
                    title: "¡Atención!",
                    message:
                        viewModel.message,
                    buttonTitle:
                        "Entendido"
                ) {
                    viewModel.closeError()
                }
                .zIndex(200)
            }
        }
        .navigationTitle(
            "Editar Perfil"
        )
        .navigationBarTitleDisplayMode(
            .inline
        )
        .toolbar(
            .hidden,
            for: .tabBar
        )
        .task {
            viewModel.load()
        }
        .onChange(
            of: selectedPhoto
        ) { _, newValue in
            guard let newValue else {
                return
            }

            Task {
                if let data =
                    try? await newValue
                        .loadTransferable(
                            type: Data.self
                        )
                {
                    await MainActor.run {
                        viewModel.setImage(
                            data
                        )
                    }
                }
            }
        }
    }

    private var packageCardColor: Color {
        Color(
            red: 0.00,
            green: 0.82,
            blue: 0.82
        )
    }

    private var registrationCardColor: Color {
        if colorScheme == .dark {
            return BeastColors.primary
        }

        return Color(
            red: 0.10,
            green: 0.32,
            blue: 0.92
        )
    }

    private var profileImage: some View {
        ZStack(
            alignment: .bottomTrailing
        ) {
            Group {
                if let image =
                    viewModel.selectedUIImage
                {
                    Image(
                        uiImage: image
                    )
                    .resizable()
                    .scaledToFill()

                } else if
                    !viewModel
                        .profileImageURL
                        .isEmpty,
                    let url = URL(
                        string:
                            viewModel
                                .profileImageURL
                    )
                {
                    AsyncImage(
                        url: url
                    ) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        avatarPlaceholder
                    }

                } else {
                    avatarPlaceholder
                }
            }
            .frame(
                width: 104,
                height: 104
            )
            .clipShape(
                Circle()
            )
            .overlay(
                Circle()
                    .stroke(
                        BeastColors.primary
                            .opacity(
                                0.35
                            ),
                        lineWidth: 1
                    )
            )

            PhotosPicker(
                selection:
                    $selectedPhoto,
                matching:
                    .images
            ) {
                ZStack {
                    Circle()
                        .fill(
                            BeastColors.primary
                        )

                    Image(
                        systemName:
                            "pencil"
                    )
                    .font(
                        .system(
                            size: 12,
                            weight: .black
                        )
                    )
                    .foregroundStyle(
                        BeastColors.buttonText
                    )
                }
                .frame(
                    width: 34,
                    height: 34
                )
            }
            .buttonStyle(
                .plain
            )
        }
        .padding(
            .top,
            18
        )
    }

    private var avatarPlaceholder: some View {
        ZStack {
            BeastColors.surface

            Image(
                systemName:
                    "person.fill"
            )
            .font(
                .system(
                    size: 36
                )
            )
            .foregroundStyle(
                BeastColors.textSecondary
            )
        }
    }

    private var formattedCreatedAt: String {
        let rawValue =
            viewModel.createdAt
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )

        if rawValue.isEmpty {
            return ""
        }

        if let date =
            Self.isoFormatterWithFractionalSeconds
                .date(
                    from: rawValue
                )
        {
            return Self.displayFormatter
                .string(
                    from: date
                )
        }

        if let date =
            Self.isoFormatter
                .date(
                    from: rawValue
                )
        {
            return Self.displayFormatter
                .string(
                    from: date
                )
        }

        if let date =
            Self.dateOnlyFormatter
                .date(
                    from: rawValue
                )
        {
            return Self.displayFormatter
                .string(
                    from: date
                )
        }

        return rawValue
    }

    private static let isoFormatter:
        ISO8601DateFormatter =
    {
        let formatter =
            ISO8601DateFormatter()

        formatter.formatOptions = [
            .withInternetDateTime
        ]

        return formatter
    }()

    private static let isoFormatterWithFractionalSeconds:
        ISO8601DateFormatter =
    {
        let formatter =
            ISO8601DateFormatter()

        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]

        return formatter
    }()

    private static let dateOnlyFormatter:
        DateFormatter =
    {
        let formatter =
            DateFormatter()

        formatter.locale =
            Locale(
                identifier: "en_US_POSIX"
            )

        formatter.dateFormat =
            "yyyy-MM-dd"

        return formatter
    }()

    private static let displayFormatter:
        DateFormatter =
    {
        let formatter =
            DateFormatter()

        formatter.locale =
            Locale(
                identifier: "es_MX"
            )

        formatter.dateFormat =
            "d 'de' MMMM 'del' yyyy"

        return formatter
    }()
}
