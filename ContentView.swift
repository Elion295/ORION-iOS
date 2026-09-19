import SwiftUI

struct ContentView: View {

    private let orionURL = URL(
        string: "https://script.google.com/macros/s/AKfycbwcOeU0PK3VqegpkaeY3N4amrAA-leLKC65yIDovFiyi5UiUEqv6mlGXle_dS6mCNXq/exec"
    )!

    @State private var message = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(
            text: "Hola. Soy ORION. ¿En qué puedo ayudarte?",
            isUser: false
        )
    ]

    @State private var isThinking = false

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            VStack(spacing: 0) {

                header

                Divider()
                    .background(Color.white.opacity(0.15))

                chat

                inputBar
            }
        }
        .preferredColorScheme(.dark)
    }


    // MARK: - HEADER

    private var header: some View {

        HStack {

            VStack(
                alignment: .leading,
                spacing: 3
            ) {

                Text("ORION")
                    .font(
                        .system(
                            size: 28,
                            weight: .bold
                        )
                    )
                    .foregroundColor(.white)

                Text("INTELLIGENCE SYSTEM")
                    .font(
                        .system(
                            size: 10,
                            weight: .medium
                        )
                    )
                    .tracking(2)
                    .foregroundColor(.cyan)
            }

            Spacer()

            Circle()
                .fill(
                    isThinking
                    ? Color.orange
                    : Color.green
                )
                .frame(
                    width: 10,
                    height: 10
                )
                .shadow(
                    color:
                        isThinking
                        ? .orange
                        : .green,
                    radius: 8
                )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }


    // MARK: - CHAT

    private var chat: some View {

        ScrollView {

            LazyVStack(
                spacing: 14
            ) {

                ForEach(messages) { msg in

                    HStack {

                        if msg.isUser {

                            Spacer()

                            Text(msg.text)
                                .foregroundColor(.white)
                                .padding(14)
                                .background(
                                    RoundedRectangle(
                                        cornerRadius: 18
                                    )
                                    .fill(
                                        Color.blue
                                            .opacity(0.35)
                                    )
                                )
                                .frame(
                                    maxWidth: 300,
                                    alignment: .trailing
                                )

                        } else {

                            HStack(
                                alignment: .top,
                                spacing: 10
                            ) {

                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                .cyan,
                                                .blue,
                                                .purple
                                            ],
                                            startPoint:
                                                .topLeading,
                                            endPoint:
                                                .bottomTrailing
                                        )
                                    )
                                    .frame(
                                        width: 34,
                                        height: 34
                                    )
                                    .overlay {

                                        Text("O")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }

                                Text(msg.text)
                                    .foregroundColor(
                                        .white.opacity(0.92)
                                    )
                                    .padding(14)
                                    .background(
                                        RoundedRectangle(
                                            cornerRadius: 18
                                        )
                                        .fill(
                                            Color.white
                                                .opacity(0.08)
                                        )
                                    )
                                    .frame(
                                        maxWidth: 300,
                                        alignment: .leading
                                    )

                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }

                if isThinking {

                    HStack {

                        ProgressView()
                            .tint(.cyan)

                        Text("ORION está pensando...")
                            .foregroundColor(
                                .white.opacity(0.6)
                            )
                            .font(.caption)

                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.vertical, 20)
        }
    }


    // MARK: - INPUT

    private var inputBar: some View {

        HStack(spacing: 10) {

            TextField(
                "Escribe a ORION...",
                text: $message
            )
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
            .background(
                RoundedRectangle(
                    cornerRadius: 20
                )
                .fill(
                    Color.white.opacity(0.08)
                )
            )
            .disabled(isThinking)


            Button {

                sendMessage()

            } label: {

                Image(
                    systemName:
                        "arrow.up"
                )
                .font(
                    .system(
                        size: 17,
                        weight: .bold
                    )
                )
                .foregroundColor(.white)
                .frame(
                    width: 45,
                    height: 45
                )
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    .cyan,
                                    .blue
                                ],
                                startPoint:
                                    .topLeading,
                                endPoint:
                                    .bottomTrailing
                            )
                        )
                )
            }
            .disabled(
                message
                    .trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )
                    .isEmpty ||
                isThinking
            )
        }
        .padding(14)
    }


    // MARK: - SEND MESSAGE

    private func sendMessage() {

        let text =
            message
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )


        guard !text.isEmpty else {
            return
        }


        messages.append(
            ChatMessage(
                text: text,
                isUser: true
            )
        )


        message = ""

        isThinking = true


        var request =
            URLRequest(
                url: orionURL
            )


        request.httpMethod = "POST"


        request.setValue(
            "application/json",
            forHTTPHeaderField:
                "Content-Type"
        )


        let body: [String: Any] = [
            "message": text
        ]


        request.httpBody =
            try? JSONSerialization.data(
                withJSONObject: body
            )


        URLSession.shared.dataTask(
            with: request
        ) { data, response, error in

            DispatchQueue.main.async {

                isThinking = false
            }


            if let error = error {

                DispatchQueue.main.async {

                    messages.append(
                        ChatMessage(
                            text:
                                "No pude conectar con ORION.\n\n" +
                                error.localizedDescription,
                            isUser: false
                        )
                    )
                }

                return
            }


            guard let data = data else {

                DispatchQueue.main.async {

                    messages.append(
                        ChatMessage(
                            text:
                                "ORION no recibió ninguna respuesta.",
                            isUser: false
                        )
                    )
                }

                return
            }


            do {

                let json =
                    try JSONSerialization.jsonObject(
                        with: data
                    ) as? [String: Any]


                if let responseText =
                    json?["response"] as? String {

                    DispatchQueue.main.async {

                        messages.append(
                            ChatMessage(
                                text:
                                    responseText,
                                isUser: false
                            )
                        )
                    }

                } else {

                    let errorText =
                        json?["error"] as? String
                        ?? "Respuesta desconocida."


                    DispatchQueue.main.async {

                        messages.append(
                            ChatMessage(
                                text:
                                    "ORION encontró un problema:\n\n" +
                                    errorText,
                                isUser: false
                            )
                        )
                    }
                }

            } catch {

                DispatchQueue.main.async {

                    messages.append(
                        ChatMessage(
                            text:
                                "No pude interpretar la respuesta de ORION.",
                            isUser: false
                        )
                    )
                }
            }

        }
        .resume()
    }
}


// MARK: - MESSAGE

struct ChatMessage: Identifiable {

    let id = UUID()

    let text: String

    let isUser: Bool
}


#Preview {

    ContentView()

}
