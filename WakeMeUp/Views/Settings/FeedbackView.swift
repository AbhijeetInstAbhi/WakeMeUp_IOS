import SwiftUI

public struct FeedbackView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var rating = 5
    @State private var selectedCategory = "Bug Report"
    @State private var message = ""
    @State private var submitted = false

    private let categories = ["Bug Report", "Feature Request", "App Review", "General"]

    public var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.09, blue: 0.16).ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Text("App Feedback")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()
                }
                .padding(16)

                if submitted {
                    VStack(spacing: 20) {
                        Spacer()

                        ZStack {
                            Circle()
                                .fill(Color(red: 0.06, green: 0.73, blue: 0.51).opacity(0.2))
                                .frame(width: 90, height: 90)
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 56, weight: .bold))
                                .foregroundColor(Color(red: 0.06, green: 0.73, blue: 0.51))
                        }

                        Text("Thank You!")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)

                        Text("Your feedback helps us make WakeMeUp better for everyone.")
                            .font(.system(size: 15))
                            .foregroundColor(Color.white.opacity(0.75))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)

                        Spacer()

                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Text("Back to Settings")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color(red: 0.22, green: 0.74, blue: 0.97))
                                .cornerRadius(16)
                        }
                        .padding(20)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            Text("How's your experience with WakeMeUp?")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)

                            HStack(spacing: 12) {
                                ForEach(1...5, id: \.self) { star in
                                    Image(systemName: star <= rating ? "star.fill" : "star")
                                        .font(.system(size: 32))
                                        .foregroundColor(star <= rating ? Color(red: 0.96, green: 0.62, blue: 0.04) : Color.white.opacity(0.3))
                                        .onTapGesture { rating = star }
                                }
                            }

                            VStack(alignment: .leading, spacing: 14) {
                                Text("FEEDBACK CATEGORY")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(Color.white.opacity(0.5))
                                    .tracking(1)

                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                                    ForEach(categories, id: \.self) { cat in
                                        let isSel = selectedCategory == cat
                                        Button(action: { selectedCategory = cat }) {
                                            Text(cat)
                                                .font(.system(size: 13, weight: isSel ? .bold : .medium))
                                                .foregroundColor(isSel ? .black : .white)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 38)
                                                .background(isSel ? Color(red: 0.22, green: 0.74, blue: 0.97) : Color.white.opacity(0.08))
                                                .cornerRadius(10)
                                        }
                                    }
                                }

                                Text("YOUR MESSAGE")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(Color.white.opacity(0.5))
                                    .tracking(1)
                                    .padding(.top, 10)

                                TextEditor(text: $message)
                                    .frame(height: 140)
                                    .padding(8)
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(14)
                                    .foregroundColor(.white)
                            }
                            .padding(18)
                            .background(Color.white.opacity(0.07))
                            .cornerRadius(20)

                            Button(action: {
                                guard !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

                                let stars = String(repeating: "★", count: rating)
                                let emailSubject = "WakeMeUp Feedback: [\(selectedCategory)] - \(rating) Stars"
                                let emailBody = """
                                Hi WakeMeUp Team,

                                Here is my feedback for the WakeMeUp iOS App:

                                --------------------------------------------------
                                RATING: \(rating) / 5 Stars (\(stars))
                                CATEGORY: \(selectedCategory)
                                --------------------------------------------------

                                USER REVIEW / FEEDBACK:
                                \(message)

                                --------------------------------------------------
                                DEVICE DETAILS:
                                App Name: WakeMeUp Location Alarms
                                Package: com.abhijeet.wakemeup
                                iOS Version: \(UIDevice.current.systemVersion)
                                Device Model: \(UIDevice.current.model)
                                --------------------------------------------------
                                """

                                if let encodedSubject = emailSubject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                                   let encodedBody = emailBody.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                                   let url = URL(string: "mailto:singhabhijeet105@gmail.com?subject=\(encodedSubject)&body=\(encodedBody)") {
                                    UIApplication.shared.open(url)
                                }
                                submitted = true
                            }) {
                                Text("Submit Feedback")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 54)
                                    .background(Color(red: 0.06, green: 0.73, blue: 0.51))
                                    .cornerRadius(16)
                            }
                        }
                        .padding(20)
                    }
                }
            }
        }
    }
}
