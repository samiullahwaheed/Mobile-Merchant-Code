/// Static User Manual content sourced from the official
/// "Rewaldo Business App User Manual" document for the Rewaldo Merchant
/// Application. Rendered as HTML via flutter_html.
const String kUserManualHtml = '''
<h3><strong>REWALDO</strong></h3>
<h4>Loyalty &amp; Rewards Platform</h4>
<h3><strong>Business App</strong></h3>
<p>In-store point-of-sale guide for issuing points and rewards using the Rewaldo mobile business (merchant) application.</p>
<h3><strong>Mobile Business Application</strong></h3>
<p><strong>User Manual: </strong>Version 1.0</p>
<h1>1. Introduction</h1>
<p>The Rewaldo Business App is the point-of-sale companion app used by retail staff to issue loyalty points, redeem customer rewards, look up customer loyalty accounts, and track daily sales performance — all from a mobile device at the counter.</p>
<p><strong>Note: </strong>This manual covers the Business (Merchant) mobile app. Business owners who need web-based reporting, staff management, and campaign tools should also refer to the Business Dashboard manual.</p>
<h1>2. Getting Started</h1>
<h2>2.1 Creating a Business Account</h2>
<ul>
<li>Install the Rewaldo Business app and select Sign Up.</li>
<li>Enter your business contact details and create a password.</li>
<li>Verify your account using the OTP sent to your registered phone/email.</li>
</ul>
<h2>2.2 Setting Up Your Shop Information</h2>
<p>Immediately after sign-up you'll be asked to complete your Shop Information:</p>
<ul>
<li>Enter Business Name.</li>
<li>Select Your Service (business category).</li>
<li>Upload Your Company Logo (Take a Photo or Choose from Gallery).</li>
<li>Enter your Country.</li>
<li>Write About Us — a short description of your business.</li>
</ul>
<p>Tap Continue once your shop profile is complete.</p>
<h2>2.3 Signing In</h2>
<ul>
<li>Open the app and select Sign In.</li>
<li>Enter your registered email/phone number and password.</li>
<li>Allow location access so the app can attach your shop's location for nearby-merchant discovery in the customer app.</li>
</ul>
<h2>2.4 Forgotten Password</h2>
<ul>
<li>Tap Forgot Password on the sign-in screen.</li>
<li>Enter your registered email/phone to receive an OTP and complete verification on the Verify OTP screen.</li>
<li>Set a new password on the Reset Password screen.</li>
</ul>
<h1>3. Home Dashboard</h1>
<p>The Home screen gives you an at-a-glance view of your store's loyalty performance, with a date filter — Today, Last 7 Days, Last 30 Days, or All Time — applied across all statistics:</p>
<p>Your shop's city and country (as set in Shop Information) are also displayed on the dashboard header.</p>
<h1>4. Sell Management</h1>
<p>Use New Transaction at the point of sale to award points and apply rewards for a customer purchase:</p>
<ul>
<li>Tap New Transaction from the home screen.</li>
<li>Find the customer by entering their loyalty Card ID (e.g. XY9OWARA) and tapping Find, or by scanning their card/QR code.</li>
<li>Enter the bill amount for the purchase.</li>
<li>Based on your eligible tier and the purchase value, the system will calculate the points to be issued and display them on the screen.</li>
<li>If the customer has an available gift card or wants to redeem points, apply it: enter the points to redeem and tap Apply Calculation. The screen will show Available Points, Gift Card Available, and the Gross Value of Promotions applied.</li>
<li>The Merchant can also apply a promotion saved by the customer.</li>
<li>Review the calculated Point Redeemed value and the adjusted total and Submit Complete Transaction.</li>
<li>The Customer will recieve a notification of the points redeemed to approve or decline.</li>
<li>Once customer approves, merchant can view the final amount in the summary.</li>
</ul>
<p><strong>Note: </strong>If the card code is not recognised, the app shows "Card not found" — double-check the code with the customer or ask them to show the code in their Rewaldo customer app.</p>
<h2>4.1 Total Summary &amp; Checkout</h2>
<p>The Total Summary screen displays the Customer Name, Card ID, Total Amount, Point Earned, Point Redeem, and Final Amount for review before completing the sale.</p>
<ul>
<li>Confirm all details are correct.</li>
<li>Tap Complete Transaction to finalise the sale.</li>
<li>The Transaction Status will confirm success.</li>
</ul>
<h2>4.2 Reviewing Sales Data</h2>
<p>Customer details and purchase history can be reviewed using different filters and search options.</p>
<h1>5. Customer Details</h1>
<ul>
<li>Open Customer Details from the main menu.</li>
<li>Use Search by Customer Name to find a specific loyalty member, or browse the list.</li>
<li>Tap View on any customer to open their full profile, including loyalty tier, points balance, and purchase history.</li>
</ul>
<p>If no results are found, the screen displays "No customers found" — check the spelling of the name or ask the customer for their loyalty Card ID instead.</p>
<h1>6. Notifications</h1>
<p>The Notifications screen keeps merchants informed about redemption requests from customers, subscription updates, and system announcements. Redemption requests submitted from the customer app arrive here in real time for review.</p>
<h1>7. Profile &amp; Settings</h1>
<h2>7.1 Edit Profile</h2>
<p>Update your account name, photo, and shop details from Profile → Change Profile Info.</p>
<h2>7.2 Change Password</h2>
<p>Go to Profile → Change Password to update your login credentials.</p>
<h2>7.3 Contact Us, Privacy Policy &amp; Terms</h2>
<p>Support and legal information are available from the profile menu at all times: Contact Us, Privacy Policy, and Terms &amp; Conditions.</p>
<h1>8. Troubleshooting &amp; Support</h1>
<p>For issues not listed here, contact support from the Contact Us screen in your profile menu.</p>
''';
