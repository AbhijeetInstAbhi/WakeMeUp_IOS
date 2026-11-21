import SwiftUI
import CoreLocation

public struct SosConfigView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var settingsRepo = SettingsRepository.shared
    @ObservedObject var locationManager = LocationManager.shared

    @State private var name: String = ""
    @State private var phone: String = ""

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

                    Text("Emergency SOS Setup")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()
                }
                .padding(16)

                ScrollView {
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(Color.red.opacity(0.2))
                                .frame(width: 80, height: 80)
                            Image(systemName: "shield.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.red)
                        }

                        Text("Emergency Contact Settings")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)

                        Text("Set an emergency contact to quickly share your live location or make a call when travelling late or in danger.")
                            .font(.system(size: 13))
                            .foregroundColor(Color.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)

                        VStack(alignment: .leading, spacing: 14) {
                            Text("CONTACT DETAILS")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color.white.opacity(0.5))
                                .tracking(1)

                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(Color(red: 0.22, green: 0.74, blue: 0.97))
                                TextField("Contact Name (e.g. Mom, Alex)", text: $name)
                                    .foregroundColor(.white)
                            }
                            .padding(12)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(14)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.15), lineWidth: 1))

                            HStack {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(Color(red: 0.22, green: 0.74, blue: 0.97))
                                TextField("Phone Number (+1234567890)", text: $phone)
                                    .keyboardType(.phonePad)
                                    .foregroundColor(.white)
                            }
                            .padding(12)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(14)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.15), lineWidth: 1))
                        }
                        .padding(18)
                        .background(Color.white.opacity(0.07))
                        .cornerRadius(20)

                        if !phone.isEmpty {
                            HStack(spacing: 10) {
                                Button(action: {
                                    var locText = ""
                                    if let loc = locationManager.userLocation {
                                        locText = " My live GPS Location: https://maps.google.com/?q=\(loc.latitude),\(loc.longitude)"
                                    }
                                    let body = "EMERGENCY SOS from WakeMeUp: I am travelling and need urgent assistance!\(locText)"
                                    if let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                                       let url = URL(string: "sms:\(phone)&body=\(encodedBody)") {
                                        UIApplication.shared.open(url)
                                    }
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "message.fill")
                                            .foregroundColor(Color(red: 0.22, green: 0.74, blue: 0.97))
                                        Text("SOS SMS")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.3), lineWidth: 1))
                                }

                                Button(action: {
                                    if let url = URL(string: "tel:\(phone)") {
                                        UIApplication.shared.open(url)
                                    }
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "phone.fill")
                                            .foregroundColor(Color(red: 0.06, green: 0.73, blue: 0.51))
                                        Text("Call SOS")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.3), lineWidth: 1))
                                }
                            }
                        }

                        Button(action: {
                            guard !name.isEmpty, !phone.isEmpty else { return }
                            settingsRepo.setSosContact(name: name, phone: phone)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Save Emergency Contact")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                                .background(Color(red: 0.06, green: 0.73, blue: 0.51))
                                .cornerRadius(16)
                        }
                        .padding(.top, 10)
                    }
                    .padding(20)
                }
            }
        }
        .onAppear {
            self.name = settingsRepo.settings.sosContactName
            self.phone = settingsRepo.settings.sosContactPhone
        }
    }
}
