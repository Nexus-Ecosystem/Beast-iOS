import SwiftUI

struct ProfileHeaderCard: View {
    let profile: ProfileDisplayModel
    let onTap: () -> Void

    var body: some View {
        Button(
            action: onTap
        ) {
            HStack(
                spacing: 16
            ) {
                avatar

                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    Text(
                        profile.fullName
                    )
                    .font(
                        .system(
                            size: 20,
                            weight: .black
                        )
                    )
                    .foregroundStyle(
                        .primary
                    )
                    .lineLimit(1)

                    Text(
                        profile.email
                    )
                    .font(
                        .system(
                            size: 11
                        )
                    )
                    .foregroundStyle(
                        .secondary
                    )
                    .lineLimit(1)

                    Text(
                        profile.phone
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
            .padding(18)
            .frame(
                maxWidth: .infinity
            )
            .background(
                RoundedRectangle(
                    cornerRadius: 24,
                    style: .continuous
                )
                .fill(
                    Color(
                        .secondarySystemBackground
                    )
                )
            )
        }
        .buttonStyle(.plain)
    }

    private var avatar: some View {
        ZStack(
            alignment: .bottomTrailing
        ) {
            ZStack {
                Circle()
                    .stroke(
                        BeastColors.primary,
                        lineWidth: 2
                    )
                    .frame(
                        width: 78,
                        height: 78
                    )

                Group {
                    if
                        !profile.photoURL.isEmpty,
                        let url = URL(
                            string: profile.photoURL
                        )
                    {
                        AsyncImage(
                            url: url
                        ) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            defaultAvatar
                        }
                    } else {
                        defaultAvatar
                    }
                }
                .frame(
                    width: 66,
                    height: 66
                )
                .clipShape(
                    Circle()
                )
            }

            ZStack {
                Circle()
                    .fill(
                        BeastColors.primary
                    )
                    .frame(
                        width: 28,
                        height: 28
                    )

                Image(
                    systemName: "pencil"
                )
                .font(
                    .system(
                        size: 11,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    Color(
                        "BeastBackground"
                    )
                )
            }
            .offset(
                x: 1,
                y: 1
            )
        }
        .frame(
            width: 82,
            height: 82
        )
    }

    private var defaultAvatar: some View {
        ZStack {
            Circle()
                .fill(
                    Color(
                        red: 0.15,
                        green: 0.17,
                        blue: 0.20
                    )
                )

            Image(
                systemName: "person.fill"
            )
            .font(
                .system(
                    size: 27
                )
            )
            .foregroundStyle(
                .secondary
            )
        }
    }
}
