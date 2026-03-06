# Guardian Circle 🛡️

A decentralized, premium family and friends safety application built for the year 2026. **Guardian Circle** leverages the power of the Polygon blockchain and real-time location tracking to ensure your loved ones are always secure, with a privacy-first, decentralized approach.

---

## ✨ Features (2026 Aesthetics)

- **Premium Glassmorphism**: High-end UI design using dynamic materials, glass gradients, and background blurs.
- **Mesh Gradient Backgrounds**: Silky, animated mesh gradients that breathe life into every screen.
- **Real-time Map Integration**: Track circle members with live MapKit annotations and dynamic status rings (Safe, Alert, SOS).
- **Web3 Emergency Broadcasting**: Trigger tamper-proof, decentralized SOS alerts on the Polygon network.
- **Siri Shortcuts (iOS 16+)**: Voice-trigger emergency alerts with "Hey Siri, Guardian SOS."
- **Privacy-First**: End-to-end encrypted location sharing (AES-256) before IPFS/Blockchain broadcast.
- **Haptic Excellence**: Deep integration of system haptics for critical feedback and security confirmation.

---

## 🛠 Tech Stack

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI (NavigationStack, Material Blurs, Symbol Effects)
- **Maps**: MapKit + CoreLocation (Always-On Background Updates)
- **Web3**: [web3.swift](https://github.com/argentlabs/web3.swift) (Polygon Network)
- **Shortcuts**: AppIntents Framework
- **Notifications**: UserNotifications (Critical Alerts)

---

## 🚀 Getting Started

To run the project locally on your Mac:

### 1. Requirements

- Xcode 15+
- iOS 16.0+ Simulator or Device
- Internet connection (for Polygon RPC and dependencies)

### 2. Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/Dipraise1/gaurdianapp.git
    cd gaurdianapp
    ```
2.  **Open in Xcode**: Open the `Package.swift` file or create a new Xcode project and import the source files in `GuardianCircle/`.
3.  **Add Dependencies**: Xcode will automatically fetch the `web3.swift` package via Swift Package Manager.
4.  **Configure Capabilities**:
    - Under your Target's **Signing & Capabilities**, add **Location Updates** and **Remote Notifications**.
5.  **Run**: Press `Cmd + R` to build and run on your preferred iOS simulator.

### 3. Usage

- **Onboarding**: Generate your unique Web3 wallet and grant location permissions.
- **Home**: View your circle members on the map.
- **SOS**: Long-press or click the SOS button. A 5-second countdown will begin before a transaction is broadcasted to the Polygon network.

---

## 🛡 Security & Privacy

Guardian Circle **never** stores your raw GPS coordinates on any centralized server.

1. Coordinates are encrypted locally using **AES-256**.
2. Encrypted data is referenced in a **Polygon Smart Contract**.
3. Only members of your circle with the shared decryption key can view your live location.

---

## 💎 Design Philosophy

Guardian Circle follows the **2026 iOS Design Language**: refined glass surfaces, vibrant monochromatic accenting, and high-frequency micro-animations. Every interaction is designed to feel premium, secure, and immediate.

---

## ⚖️ License

This project is licensed under the MIT License - see the LICENSE file for details.
