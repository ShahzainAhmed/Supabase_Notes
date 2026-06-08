# Supabase Learning Notes

## Database Types

### Firebase Firestore (NoSQL)

* NoSQL Database
* Stores data as **Collections** and **Documents**
* Structure is similar to JSON
* Flexible schema

Example Document:

```json
{
  "name": "Ali",
  "email": "ali@gmail.com",
  "xp": 100
}
```

---

### Supabase (SQL)

* Supabase is a Backend Platform
* Uses **PostgreSQL** as its database
* Stores data in **Tables, Rows, and Columns**
* Similar to Excel sheets
* Better for relationships and complex queries

Example:

| id | name  | xp  |
| -- | ----- | --- |
| 1  | Ali   | 100 |
| 2  | Ahmed | 200 |

---

# Relationship Concept

A relationship links tables together using IDs.

## Users Table

| id | name  |
| -- | ----- |
| 1  | Ali   |
| 2  | Ahmed |

## Appointments Table

| id | user_id |
| -- | ------- |
| 1  | 2       |

### Understanding the Relationship

```
Appointments.user_id = 2
```

↓

```
Users.id = 2
```

↓

```
Ahmed
```

### Result

```
Appointment 1 belongs to Ahmed
```

---

# Important Rule

When you see:

```text
user_id = 2
```

Don't think:

```text
Just number 2
```

Think:

```text
Go find Users.id = 2
```

That is the relationship.

---

# Common Relationship Examples

```text
user_id         → users.id

course_id       → courses.id

reward_id       → rewards.id

achievement_id  → achievements.id
```

---

# Why Relationships?

Without relationships:

```text
Appointment 1 → Ahmed

Appointment 2 → Ahmed

Appointment 3 → Ahmed
```

The name "Ahmed" is stored repeatedly.

If Ahmed changes his name, every record must be updated.

---

With relationships:

```text
Appointment 1 → user_id = 2

Appointment 2 → user_id = 2

Appointment 3 → user_id = 2
```

Only update:

```text
Users.id = 2
```

once.

All related records remain connected automatically.

### Benefits

* Less duplicate data
* Easier updates
* Better organization
* Better scalability
* Cleaner database design

---

# Relationship Table Example

## Users

| id | name     |
| -- | -------- |
| 1  | Ali      |
| 2  | Ahmed    |
| 3  | Shahzain |

## Courses

| id | title    |
| -- | -------- |
| 1  | Flutter  |
| 2  | Supabase |
| 3  | SQL      |

## User_Courses

| user_id | course_id |
| ------- | --------- |
| 3       | 2         |

### Understanding

```
user_id = 3
```

↓

```
Users.id = 3
```

↓

```
Shahzain
```

AND

```
course_id = 2
```

↓

```
Courses.id = 2
```

↓

```
Supabase
```

### Result

```text
Shahzain
     ↓
Supabase
```

Meaning:

> Shahzain is enrolled in the Supabase course.

---

# Purpose of Each Table

### Users Table

Stores:

```text
Who are the users?
```

### Courses Table

Stores:

```text
What courses exist?
```

### User_Courses Table

Stores:

```text
Which user is enrolled in which course?
```

The relationship table contains the actual connection.

---

# Interview Question

### What is a Relationship in SQL?

A relationship in SQL links tables together using IDs. For example, a `user_id` in one table can refer to the `id` of a user in another table, allowing related data to stay connected without duplication.

---

# Supabase Summary

* Backend Platform
* Uses PostgreSQL Database
* Authentication
* Database
* Storage
* Realtime Features

Common Startup Stack:

```text
Flutter
    ↓
Supabase
    ↓
PostgreSQL
```

---

# Biggest Learning Today

Whenever you see:

```text
user_id
course_id
reward_id
achievement_id
```

Ask yourself:

> Which table's `id` is this pointing to?

That answer is the relationship.

---

# Supabase Authentication

## Authentication vs Database

Supabase Authentication and PostgreSQL Database are separate things.

Supabase Structure:

```text
Supabase
│
├── Authentication
│     └── Users
│
└── PostgreSQL Database
      └── Tables
```

When using:

```dart
supabase.auth.signUp(...)
```

User is created inside:

```text
Authentication → Users
```

Not inside PostgreSQL tables.

---

# Supabase Initialization

Before using Supabase:

```dart
await Supabase.initialize(
  url: 'PROJECT_URL',
  anonKey: 'ANON_KEY',
);
```

Purpose:

* Connect Flutter app to Supabase project
* Initialize Authentication
* Initialize Database access
* Initialize Storage access

Without initialization:

```text
Flutter ❌ Supabase
```

After initialization:

```text
Flutter
   ↓
Supabase
```

---

# URL Mistake

Correct:

```text
https://project-id.supabase.co
```

Wrong:

```text
https://project-id.supabase.co/rest/v1/
```

Supabase SDK automatically handles internal API paths.

Only provide the base project URL.

---

# Anon Key vs Service Role Key

Anon Key:

* Used inside Flutter apps
* Safe for client-side usage
* Limited by Supabase security rules

Service Role Key:

* Backend only
* Administrative access
* Can bypass security policies
* Never expose in Flutter

Interview Answer:

```text
Anon Key → Frontend

Service Role Key → Backend
```

---

# Understanding signUp()

```dart
final response = await supabase.auth.signUp(
  email: email,
  password: password,
);
```

Flow:

```text
User enters data
      ↓
Flutter sends request
      ↓
Supabase creates user
      ↓
Supabase returns response
      ↓
Flutter receives response
```

Response contains information about the newly created user.

---

# Understanding await

Example:

```dart
await supabase.auth.signUp(...)
```

Meaning:

```text
Wait until Supabase finishes processing the request.
```

Flutter pauses execution until a response is received.

---

# Form Validation

```dart
if (!_formKey.currentState!.validate()) return;
```

Meaning:

```text
If form is invalid,
stop execution immediately.
```

Purpose:

* Prevent empty email
* Prevent invalid email
* Prevent weak password
* Avoid unnecessary API calls

---

# mounted

```dart
if (!mounted) return;
```

Meaning:

```text
If widget/screen is no longer attached to UI,
stop execution.
```

Common scenario:

```text
User presses Sign Up
        ↓
API request starts
        ↓
User leaves screen
        ↓
API response returns
```

Without mounted check:

```text
Trying to use a dead context
```

may cause errors.

---

# Understanding Response

```dart
final response = await supabase.auth.signUp(...)
```

Response contains data returned from Supabase.

Example:

```text
User ID
Email
Authentication Data
```

---

# Why Check response.user != null ?

```dart
if (response.user != null)
```

Meaning:

```text
Was a user actually created?
```

If:

```dart
response.user == null
```

then user creation failed.

If:

```dart
response.user != null
```

then signup succeeded.

Purpose:

```text
Only show success when a real user exists.
```

---

# Error Handling

```dart
try {
   ...
} catch (error) {
   ...
}
```

Meaning:

```text
Try running code.

If something fails,
catch the error and handle it.
```

Examples:

* No internet
* Invalid URL
* Server failure
* Authentication failure

Instead of crashing the app:

```text
Show friendly error message.
```

---

# Biggest Learning

Whenever you see:

```dart
await something.doAction(...)
```

Think:

```text
Call external service
      ↓
Wait for response
      ↓
Receive result
      ↓
Handle success/error
```

This pattern is used everywhere:

* Supabase
* Firebase
* REST APIs
* Payment Gateways
* AI APIs
* Third-party SDKs

---

# Google Authentication with Supabase

## Required Package

Add Google Sign-In package:

```yaml
google_sign_in: latest_version
```

Then run:

```bash
flutter pub get
```

Purpose:

* Opens Google account selector
* Retrieves Google user information
* Retrieves authentication tokens
* Allows login through Google accounts

---

# Supabase Google Provider Setup

Open:

```text
Supabase Dashboard
    ↓
Authentication
    ↓
Providers
    ↓
Google
```

Enable:

```text
Google Provider
```

You will be asked to provide:

```text
Web Client ID
Android Client ID
iOS Client ID
```

Multiple Client IDs can be entered and separated by commas.

---

# Getting Client IDs

Open:

```text
Google Cloud Console
    ↓
Project
    ↓
APIs & Services
    ↓
Credentials
```

Create OAuth Clients for:

```text
Web
Android
iOS
```

Each platform generates its own Client ID.

Example:

```text
Web Client ID
Android Client ID
iOS Client ID
```

These Client IDs are later used by:

```text
Flutter
Supabase
Google OAuth
```

to verify application identity.

---

# Environment Variables

Store Client IDs inside `.env`

Example:

```env
WEB_CLIENT=xxxxxxxx.apps.googleusercontent.com

ANDROID_CLIENT=xxxxxxxx.apps.googleusercontent.com

IOS_CLIENT=xxxxxxxx.apps.googleusercontent.com
```

Purpose:

* Keeps secrets out of source code
* Easier environment management
* Avoids hardcoding credentials

---

# Google Sign-In Flow

```text
User presses Continue with Google
            ↓
Google Account Picker Opens
            ↓
User Selects Account
            ↓
Google Returns Tokens
            ↓
Flutter Receives Tokens
            ↓
Supabase Verifies Tokens
            ↓
Session Created
            ↓
User Logged In
```

---

# Understanding Google Sign-In Code

## Step 1: Initialize Google Sign-In

```dart
GoogleSignIn googleSignIn = GoogleSignIn.instance;

await googleSignIn.initialize(
  serverClientId: dotenv.env['WEB_CLIENT']!,
  clientId: Platform.isIOS
      ? dotenv.env['IOS_CLIENT']!
      : dotenv.env['ANDROID_CLIENT']!,
);
```

Purpose:

* Initializes Google SDK
* Connects app with Google OAuth credentials
* Uses platform-specific client IDs

---

## Step 2: Authenticate User

```dart
GoogleSignInAccount account =
    await googleSignIn.authenticate();
```

Purpose:

```text
Display Google Account Selection Screen
```

User selects:

```text
Gmail Account
```

Google returns:

```text
GoogleSignInAccount
```

containing user information.

---

## Step 3: Retrieve ID Token

```dart
String idToken =
    account.authentication.idToken ?? '';
```

Purpose:

```text
Retrieve Google Identity Token
```

The ID Token proves:

```text
Google has authenticated this user
```

---

## Step 4: Request Authorization

```dart
final authorization =
    await account.authorizationClient
        .authorizationForScopes(
          ['email', 'profile'],
        ) ??
    await account.authorizationClient
        .authorizeScopes(
          ['email', 'profile'],
        );
```

Purpose:

Request access to:

```text
Email
Profile
```

Google returns:

```text
Access Token
```

which allows access to approved user information.

---

## Step 5: Authenticate with Supabase

```dart
final response =
    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: authorization.accessToken,
    );
```

Purpose:

```text
Send Google Tokens
          ↓
Supabase Verifies Tokens
          ↓
Create Supabase Session
          ↓
Login User
```

This is where Google Authentication and Supabase Authentication become connected.

---

# Success Check

```dart
if (response.user != null &&
    response.session != null)
```

Purpose:

Verify:

```text
User Exists
AND
Session Exists
```

If both exist:

```text
Google Login Successful
```

---

# Session Concept

After successful login:

```text
Google
    ↓
Supabase
    ↓
Session Created
```

Session allows user to remain logged in.

Without a session:

```text
Authenticated User ❌
```

With a session:

```text
Authenticated User ✅
```

---

# iOS URL Scheme Issue

Common Error:

```text
Your app is missing support for the following URL schemes
```

Reason:

```text
Google Login Opens Safari
          ↓
Google Needs A Way Back To App
          ↓
iOS Cannot Find App URL Scheme
```

Fix:

Add URL Scheme inside:

```text
ios/Runner/Info.plist
```

Example:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>
      com.googleusercontent.apps.xxxxx
      </string>
    </array>
  </dict>
</array>
```

Purpose:

```text
Allow Google To Redirect Back To Flutter App
```

---

# Interview Question

### Why do we need both Google and Supabase?

Answer:

Google is responsible for authenticating the user and providing identity tokens. Supabase verifies those tokens and creates its own authenticated session, allowing the user to access the application's backend securely.

---

# Biggest Learning

```text
Google
    ↓
Returns Identity Tokens
    ↓
Flutter
    ↓
Supabase
    ↓
Creates Session
    ↓
User Logged In
```

Google proves who the user is.

Supabase creates and manages the application's authenticated session.

---

# Create Tables & Perform Full CRUD

Today I learned how to create a table in Supabase and perform full CRUD operations from Flutter.

CRUD means:

```text
C → Create
R → Read
U → Update
D → Delete
```

In this topic, I worked with a `Notes` table.

---

## Notes Table

The table used in Supabase was:

```text
Notes
```

Example columns:

| Column      | Purpose          |
| ----------- | ---------------- |
| id          | Unique note id   |
| title       | Note title       |
| description | Note description |

---

# Create, Insert Note

To add a new note, I used:

```dart
await supabase.from("Notes").insert({
  'title': title.text,
  'description': description.text,
});
```

This inserts a new row into the `Notes` table.

---

# Read, Fetch Notes

To fetch notes from Supabase, I used:

```dart
final result = await supabase.from("Notes").select();
```

Then I stored the result in a list:

```dart
setState(() {
  notes = result;
});
```

After fetching notes, I displayed them using `ListView` and `ListTile`.

```dart
ListView(
  children: [
    for (var note in notes)
      ListTile(
        title: Text(note['title'] ?? 'No Title'),
        subtitle: Text(note['description'] ?? 'No Description'),
      )
  ],
)
```

---

# Loading Indicator

I used `isLoading` to show a `CircularProgressIndicator` while data is being fetched.

```dart
body: isLoading
    ? Center(child: CircularProgressIndicator())
    : ListView(
        children: [
          for (var note in notes)
            ListTile(
              title: Text(note['title'] ?? 'No Title'),
              subtitle: Text(note['description'] ?? 'No Description'),
            )
        ],
      ),
```

Important point:

```dart
isLoading = true;
```

should be set before fetching data.

```dart
isLoading = false;
```

should be set after the request is complete.

---

# Delete Note

To delete a note, I used:

```dart
await supabase.from("Notes").delete().eq('id', note['id']);
```

Here:

```dart
.eq('id', note['id'])
```

means delete the row where the table `id` matches the selected note id.

Example:

```text
Delete note where id = selected note id
```

I added this inside an `IconButton`:

```dart
IconButton(
  onPressed: () async {
    try {
     await supabase.from("Notes").delete().eq('id', note['id']);
      print("Deleted note: ${note['title'] ?? 'No Title'}, ${note['description'] ?? 'No Description'}",);
    } catch (e) {
      print("Error deleting note: $e");
    }
  },
  icon: Icon(Icons.delete),
)
```

---

# Update Note

To update a note, I passed the selected note to another screen.

```dart
onTap: () => Get.to(() => UpdateNotesScreen(note: note)),
```

In the update screen, I received the note like this:

```dart
final Map<String, dynamic> note;
```

Then I filled the text fields with the existing note data:

```dart
@override
void initState() {
  title.text = widget.note['title'] ?? "";
  description.text = widget.note['description'] ?? "";
  super.initState();
}
```

To update the note in Supabase, I used:

```dart
await supabase.from("Notes").update({
  'title': title.text,
  'description': description.text,
}).eq('id', widget.note['id']);
```

Here:

```dart
.eq('id', widget.note['id'])
```

means update only the selected note.

---

# Home Screen Summary

The Home Screen is responsible for:

* Fetching notes
* Showing notes in a list
* Opening the Add Notes screen
* Opening the Update Notes screen
* Deleting notes
* Logging out

Important code:

```dart
Future<void> getNotes() async {
  setState(() {
    isLoading = true;
  });

  try {
    final result = await supabase.from("Notes").select();

    setState(() {
      notes = result;
    });

    debugPrint("Notes: $notes");
  } catch (e) {
    debugPrint("Error fetching notes: $e");
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}
```

---

# Add Notes Screen Summary

The Add Notes screen is responsible for inserting a new note into Supabase.

Important code:

```dart
Future<void> addNote() async {
  try {
    setState(() {
      isLoading = true;
    });

    await supabase.from("Notes").insert({
      'title': title.text,
      'description': description.text,
    });

    print("Note added: ${title.text}, ${description.text}");
  } catch (e) {
    print("Error adding note: $e");
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}
```

---

# Update Notes Screen Summary

The Update Notes screen is responsible for editing an existing note.

Important code:

```dart
Future<void> updateNote() async {
  try {
    setState(() {
      isLoading = true;
    });

    await supabase.from("Notes").update({
      'title': title.text,
      'description': description.text,
    }).eq('id', widget.note['id']);

    print("Note updated: ${title.text}, ${description.text}");
  } catch (e) {
    print("Error updating note: $e");
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}
```

---

# Important Concepts Learned

## `.insert()`

Used to add new data into the table.

```dart
supabase.from("Notes").insert({...});
```

## `.select()`

Used to fetch data from the table.

```dart
supabase.from("Notes").select();
```

## `.delete()`

Used to delete data from the table.

```dart
supabase.from("Notes").delete();
```

## `.update()`

Used to update existing data in the table.

```dart
supabase.from("Notes").update({...});
```

## `.eq()`

Used to apply a condition.

```dart
.eq('id', note['id'])
```

Meaning:

```text
where id equals note['id']
```

---

# Final Understanding

Today I learned how to connect Flutter with a Supabase table and perform complete CRUD operations.

I can now:

* Add notes to Supabase
* Fetch notes from Supabase
* Display notes in Flutter
* Delete notes from Supabase
* Update notes from Flutter
* Use loading indicators while requests are running
* Use `.eq()` to target a specific row

This completed the basic notes CRUD flow using Flutter and Supabase.
