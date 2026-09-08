import SwiftUI
import PencilKit

struct PrivacySignatureView: View {
    @Environment(\.dismiss)
    private var dismiss

    @StateObject private var viewModel =
        PrivacySignatureViewModel()

    @State
    private var canvasView =
        PKCanvasView()

    @State
    private var isSigning = false

    var onSignatureComplete:
        () -> Void = {}

    var body: some View {
        ZStack {
            BeastColors.background
                .ignoresSafeArea()

            VStack(
                spacing: 0
            ) {
                ScrollView(
                    showsIndicators: false
                ) {
                    VStack(
                        spacing: 24
                    ) {
                        legalCard

                        signatureSection

                        signButton

                        Text(
                            "AL PRESIONAR \"FIRMAR\", CONFIRMAS QUE HAS LEÍDO Y ACEPTAS LOS TÉRMINOS ANTERIORES."
                        )
                        .font(
                            .system(
                                size: 9,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(
                            BeastColors.textSecondary
                        )
                        .multilineTextAlignment(
                            .center
                        )
                        .padding(
                            .horizontal,
                            24
                        )

                        Spacer()
                            .frame(
                                height: 30
                            )
                    }
                    .padding(
                        .horizontal,
                        20
                    )
                    .padding(
                        .top,
                        16
                    )
                }
                .scrollDisabled(
                    isSigning
                )
            }

            if viewModel.isLoading {
                BeastLoadingOverlay(
                    message:
                        "Firmando responsiva..."
                )
                .zIndex(
                    100
                )
            }

            if viewModel.showSuccess {
                BeastAlertDialog(
                    style: .success,
                    title:
                        "¡Felicidades!",
                    message:
                        viewModel.successMessage,
                    buttonTitle:
                        "Entendido"
                ) {
                    viewModel.closeSuccess()

                    onSignatureComplete()

                    dismiss()
                }
                .zIndex(
                    200
                )
            }

            if viewModel.showError {
                BeastAlertDialog(
                    style: .error,
                    title:
                        "¡Atención!",
                    message:
                        viewModel.errorMessage,
                    buttonTitle:
                        "Entendido"
                ) {
                    viewModel.closeError()
                }
                .zIndex(
                    300
                )
            }
        }
        .navigationTitle(
            "Responsiva"
        )
        .navigationBarTitleDisplayMode(
            .inline
        )
        .toolbar(
            .hidden,
            for: .tabBar
        )
    }

    private var legalCard:
        some View
    {
        VStack(
            alignment: .leading,
            spacing: 24
        ) {
            LegalSectionView(
                number: "1",
                title:
                    "CONDICIÓN FÍSICA Y SALUD DEL USUARIO",
                content:
                    "Al inscribirte y utilizar nuestras instalaciones, declaras bajo protesta de decir verdad que te encuentras en óptimas condiciones físicas y de salud para realizar actividades de alta intensidad. Es tu responsabilidad exclusiva informar al instructor sobre cualquier padecimiento, lesión, embarazo o condición médica preexistente antes de iniciar la sesión."
            )

            LegalSectionView(
                number: "2",
                title:
                    "USO RESPONSABLE DE EQUIPOS Y BICICLETAS",
                content:
                    "Te comprometes a utilizar las bicicletas, pesas y cualquier otro equipo del estudio siguiendo estrictamente las instrucciones del instructor y las guías de seguridad del fabricante. Cualquier daño derivado de un uso negligente, alteración no autorizada o incumplimiento de las normas técnicas será responsabilidad financiera directa del usuario."
            )

            LegalSectionView(
                number: "3",
                title:
                    "CUMPLIMIENTO DE INSTRUCCIONES",
                content:
                    "La seguridad dentro del estudio depende de la disciplina. Te comprometes a seguir todas las indicaciones, ajustes de intensidad y protocolos de seguridad proporcionados por el instructor en todo momento. El estudio se reserva el derecho de retirar de la sesión a cualquier persona que actúe de manera insegura o que ponga en riesgo su integridad o la de terceros."
            )

            LegalSectionView(
                number: "4",
                title:
                    "DESLINDE DE RESPONSABILIDAD POR ACCIDENTES",
                content:
                    "Reconoces que el entrenamiento de alta intensidad conlleva riesgos inherentes de lesiones físicas. Mediante la presente, liberas a BEAST STRENGTH STUDIO, sus instructores, dueños y empleados de cualquier responsabilidad civil o penal ante accidentes, lesiones, desvanecimientos o daños personales ocurridos dentro o fuera de las instalaciones, derivados de tu participación voluntaria en nuestras actividades."
            )

            LegalSectionView(
                number: "5",
                title:
                    "RESPONSABILIDAD POR OBJETOS PERSONALES",
                content:
                    "El estudio no se hace responsable por la pérdida, robo o daño de objetos personales (celulares, llaves, ropa, equipo electrónico) dentro de nuestras instalaciones. Recomendamos el uso de los espacios designados y mantener tus pertenencias bajo tu estricta supervisión durante la clase."
            )
        }
        .padding(
            20
        )
        .background(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
            .fill(
                BeastColors.surface
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
            .stroke(
                BeastColors.border,
                lineWidth: 1
            )
        )
    }

    private var signatureSection:
        some View
    {
        VStack(
            spacing: 12
        ) {
            HStack {
                Text(
                    "Firma Digital"
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

                Spacer()

                Button {
                    canvasView.drawing =
                        PKDrawing()
                } label: {
                    HStack(
                        spacing: 5
                    ) {
                        Image(
                            systemName:
                                "trash.fill"
                        )

                        Text(
                            "Limpiar Firma"
                        )
                    }
                    .font(
                        .system(
                            size: 10,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        BeastColors.textPrimary
                    )
                    .padding(
                        .horizontal,
                        12
                    )
                    .padding(
                        .vertical,
                        8
                    )
                    .background(
                        BeastColors.surface
                    )
                    .clipShape(
                        Capsule()
                    )
                }
                .buttonStyle(
                    .plain
                )
            }

            SignaturePadView(
                canvasView:
                    $canvasView,
                isSigning:
                    $isSigning
            )
            .frame(
                height: 180
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 14
                )
            )
        }
    }

    private var signButton:
        some View
    {
        Button {
            sign()
        } label: {
            Text(
                "FIRMAR →"
            )
            .font(
                .system(
                    size: 14,
                    weight: .black
                )
            )
            .italic()
            .foregroundStyle(
                BeastColors.buttonText
            )
            .frame(
                maxWidth: .infinity
            )
            .frame(
                height: 56
            )
            .background(
                BeastColors.primary
            )
            .clipShape(
                Capsule()
            )
        }
        .buttonStyle(
            .plain
        )
    }

    private func sign() {
        guard
            !canvasView.drawing.strokes.isEmpty
        else {
            return
        }

        let bounds =
            canvasView.drawing.bounds

        guard
            !bounds.isEmpty
        else {
            return
        }

        let image =
            canvasView.drawing.image(
                from:
                    bounds.insetBy(
                        dx: -20,
                        dy: -20
                    ),
                scale:
                    UIScreen.main.scale
            )

        Task {
            await viewModel.sign(
                image: image
            )
        }
    }
}

private struct LegalSectionView:
    View
{
    let number: String
    let title: String
    let content: String

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Text(
                "\(number). \(title)"
            )
            .font(
                .system(
                    size: 14,
                    weight: .bold
                )
            )
            .italic()
            .foregroundStyle(
                BeastColors.textPrimary
            )

            Text(
                content
            )
            .font(
                .system(
                    size: 13
                )
            )
            .foregroundStyle(
                BeastColors.textSecondary
            )
            .lineSpacing(
                4
            )
        }
    }
}
