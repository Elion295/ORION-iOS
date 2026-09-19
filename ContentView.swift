import SwiftUI

struct ContentView: View {
    @State private var message = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(
            text: "Hola. Soy ORION. ¿En qué puedo ayudarte?",
            isUser: false
        )
    ]

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: - Encabezado
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("ORION")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)

                        Text("INTELLIGENCE SYSTEM")
                            .font(.system(size: 10, weight: .medium))
                            .tracking(2)
                            .foregroundColor(.cyan)
                    }

                    Spacer()

                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                        .shadow(color: .green, radius: 8)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)

                Divider()
                    .background(Color.white.opacity(0.15))

                // MARK: - Chat
                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(messages) { msg in
                            HStack {
                                if msg.isUser {
                                    Spacer()

                                    Text(msg.text)
                                        .foregroundColor(.white)
                                        .padding(14)
                                        .background(
                                            RoundedRectangle(cornerRadius: 18)
                                                .fill(Color.blue.opacity(0.35))
                                        )
                                        .frame(maxWidth: 300, alignment: .trailing)
                                } else {
                                    HStack(alignment: .top, spacing: 10) {
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [.cyan, .blue, .purple],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 34, height: 34)
                                            .overlay(
                                                Text("O")
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                            )

                                        Text(msg.text)
                                            .foregroundColor(.white.opacity(0.92))
                                            .padding(14)
                                            .background(
                                                RoundedRectangle(cornerRadius: 18)
                                                    .fill(Color.white.opacity(0.08))
                                            )
                                            .frame(maxWidth: 300, alignment: .leading)

                                        Spacer()
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.vertical, 20)
                }

                // MARK: - Entrada
                HStack(spacing: 10) {
                    TextField(
                        "Escribe a ORION...",
                        text: $message
                    )
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 13)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.08))
                    )

                    Button {
                        sendMessage()
                    } label: {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 45, height: 45)
                            .background(
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.cyan, .blue],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                    }
                }
                .padding(14)
            }
        }
        .preferredColorScheme(.dark)
    }

    private func sendMessage() {
        let text = message.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !text.isEmpty else { return }

        messages.append(
            ChatMessage(
                text: text,
                isUser: true
            )
        )

        message = ""

        // Respuesta temporal.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            messages.append(
                ChatMessage(
                    text: "Mensaje recibido. Mi conexión con Gemini se configurará en el siguiente paso.",
                    isUser: false
                )
            )
        }
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

#Preview {
    ContentView()
}
