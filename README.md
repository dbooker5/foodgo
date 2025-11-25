# FoodGo - Flutter Food Delivery App

FoodGo is a modern, feature-rich food delivery application built with Flutter. It provides a seamless user experience for browsing food categories, viewing product details, managing orders, and processing payments securely.

## 🚀 Key Features

*   **User Authentication**: Secure login and sign-up functionality using Firebase Authentication.
*   **Food Browsing**: Explore various food categories like Burgers, Pizza, Mexican, and Chinese.
*   **Product Details**: Detailed view of food items with descriptions and pricing.
*   **Order Management**: Add items to cart and manage orders.
*   **Wallet & Payments**: Integrated digital wallet and secure payment processing using Stripe.
*   **User Profile**: Manage user details and preferences.
*   **Onboarding**: Smooth onboarding experience for new users.

## 🛠️ Tech Stack

*   **Frontend**: [Flutter](https://flutter.dev/)
*   **Backend**: [Firebase](https://firebase.google.com/) (Authentication, Cloud Firestore)
*   **Payment**: [Stripe](https://stripe.com/)
*   **State Management**: `setState` (and potentially others as the app scales)
*   **Local Storage**: `shared_preferences`
*   **Networking**: `http`

## 🏁 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

*   [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
*   [Firebase CLI](https://firebase.google.com/docs/cli) installed and logged in.
*   A Stripe account for payment testing.

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/yourusername/foodgo.git
    cd foodgo
    ```

2.  **Install dependencies**
    ```bash
    flutter pub get
    ```

3.  **Configuration**

    *   **Firebase Setup**:
        This project uses `flutter_dotenv` for environment variables and likely requires a valid `firebase_options.dart` file.
        Run the following command to configure Firebase for your project:
        ```bash
        flutterfire configure
        ```

    *   **Environment Variables**:
        Create a `.env` file in the root directory and add your necessary keys (e.g., Stripe keys).
        ```env
        STRIPE_SECRET=your_stripe_secret_key
        STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key
        ```
        *Note: Ensure `.env` is added to your `.gitignore`.*

4.  **Run the Application**
    ```bash
    flutter run
    ```

## 📂 Project Structure

The project structure is organized as follows:

*   `lib/pages/`: Contains the UI screens of the application.
    *   `home.dart`: Main dashboard.
    *   `login.dart` / `signup.dart`: Authentication screens.
    *   `detail_page.dart`: Product details.
    *   `wallet.dart`: Payment and wallet interface.
*   `lib/service/`: Contains business logic and data services.
    *   `database.dart`: Firestore interactions.
    *   `shared_pref.dart`: Local storage helpers.
    *   `auth.dart`: Authentication services.
*   `lib/model/`: Data models (not visible in root listing but implied).

## 🤝 Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

## 📞 Support

If you have any questions or run into issues, please open an issue in the repository.
