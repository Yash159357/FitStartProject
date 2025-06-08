# 🏋️‍♂️ FitStart Onboarding App

A sleek and modern onboarding flow built using **Flutter**, designed for the **FitStart** health app.  
Collects user input (Height, Weight, Age) with clean UI, smooth transitions, and FitStart's custom branding.

[🔗 **GitHub Repo**](https://github.com/Yash159357/FitStartProject)

---

## ✨ Features

- 🧭 **PageView Onboarding Flow** - Smooth navigation between screens
- 📏 **Input Collection** - Height, Weight, Age with validation
- 🎨 **Branded Design** - FitStart colors and custom styling
- ✅ **Completion Screen** - Polished onboarding finish
- 💡 **Clean Code** - Modular and maintainable Flutter architecture
- 📱 **Responsive Layout** - Works across all device sizes

---

## 🧱 Tech Stack

| Tool              | Purpose                    |
|-------------------|----------------------------|
| **Flutter (3.x)** | UI Framework              |
| **Dart**          | Programming Language       |
| **PageView**      | Onboarding navigation      |
| **Custom Widgets**| Input fields, buttons, etc.|

---

## 🎨 Theme & Branding

| Color        | Hex Code   | Usage                |
|--------------|------------|----------------------|
| **Green**    | `#BFFF00`  | FitStart Primary     |
| **Dark Grey**| `#2C2C2C`  | Background/Base      |

---

## 🖼️ Screenshots

<div align="center">

| 🔹 **Splash Screen** | 🔹 **Onboarding Flow** | 🔹 **Completion Screen** |
|:---:|:---:|:---:|
| <img src="https://github.com/Yash159357/FitStartProject/blob/main/assets/splash_screen.png" width="250" alt="Splash Screen"/> | <img src="https://github.com/Yash159357/FitStartProject/blob/main/assets/onboarding_screen.png" width="250" alt="Onboarding Screen"/> | <img src="https://github.com/Yash159357/FitStartProject/blob/main/assets/complete_screen.png" width="250" alt="Complete Screen"/> |
| *Clean branded splash* | *User input collection* | *Onboarding completion* |

</div>

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.x or higher)
- Dart SDK
- Android Studio / VS Code

### Installation

```bash
# Clone the repository
git clone https://github.com/Yash159357/FitStartProject.git

# Navigate to project directory
cd FitStartProject

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Building APK

```bash
# Build release APK
flutter build apk --release

# Build split APKs (recommended)
flutter build apk --split-per-abi

# Find your APK in: build/app/outputs/flutter-apk/
```

---

## 📂 Project Structure

```
lib/
├── main.dart
├── core/
│   └── theme/
│       ├── colors.dart
│       └── text_styles.dart
├── onboarding/
│   ├── view/
│   │   ├── onboarding_screen.dart
│   │   ├── welcome_screen.dart
│   │   └── complete_screen.dart
│   ├── pages/
│   │   ├── height_page.dart
│   │   ├── weight_page.dart
│   │   └── age_page.dart
│   └── widgets/
│       ├── input_field.dart
│       ├── next_button.dart
│       └── progress_dots.dart
```

---

## 👨‍💻 Developed By

**Yash**  
Flutter Developer & Computer Science Student  
📍 New Delhi, India  
🔗 [GitHub @Yash159357](https://github.com/Yash159357)

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**Made with ❤️ and Flutter**

*If you found this project helpful, please consider giving it a ⭐*

</div>
