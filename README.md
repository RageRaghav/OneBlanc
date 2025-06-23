🍽️ Restaurant Food Ordering App
A fully functional and modern Flutter-based mobile application designed to simplify food ordering from local restaurants. This app provides a seamless user experience — from discovering cuisines and exploring menus to placing orders and applying custom filters based on budget, cuisine type, and ratings.

✨ Features
🏠 Home Screen
Cuisines Showcase: Scrollable horizontal view to explore available cuisine types (e.g., North Indian, Chinese).

Top Dishes: Displays top-rated dishes with star ratings to guide the user’s choice.

Previous Orders: Users can view their past orders with details like order date, time, order ID, total amount, and a button to re-view the order.

🎛️ Filters Screen
Cuisine Type Dropdown: Select from a variety of cuisine types.

Price Range Slider: Set a minimum and maximum price to match your budget.

Minimum Rating Selector: Filter dishes based on the lowest acceptable rating.

Clear Filters Button: Instantly reset all selected filters.

Apply Filters Button: Filters are applied and the home screen updates accordingly.

📋 Menu Screen
Dynamic Menu Listing: Displays a restaurant's menu with images, names, and prices of items.

Item Quantity Control: Users can add items to their order by tapping the "+" icon.

Cart Summary: Button at the bottom of the screen allows users to proceed to checkout.

🧾 Order Placement Screen
Order Summary: Lists all selected items with quantity and individual prices.

Cost Breakdown:

Subtotal (Net Total)

Tax Calculation (5% CGST + SGST)

Final Grand Total

Place Order Button: Confirms and places the order.

🛠️ Technologies Used
Flutter: Frontend framework for cross-platform mobile development.

Dart: Programming language used for writing business logic.

Provider: For state management (filters, cart).

Material Design: UI/UX styling components.

🧪 Testing & Validation
Real-time Data Handling: Menu and order details update based on filter selections and user interactions.

UI Responsiveness: Smooth and consistent UI experience across various device sizes.

📌 Future Enhancements (Optional Ideas)
Integration with a backend for storing and retrieving real orders and user data.

Authentication (Login/Signup).

Real-time notifications for order updates.

Multiple restaurant support.

📸 App Screenshots
Filters	Home	Menu	Order

📦 Setup Instructions
Clone the repository:

bash
Copy
Edit
git clone <your_repo_url>
cd food_ordering_app
Install dependencies:

bash
Copy
Edit
flutter pub get
Run the app:

bash
Copy
Edit
flutter run
👨‍💻 Developer
Made with ❤️ using Flutter and Dart to deliver an elegant food ordering experience.
