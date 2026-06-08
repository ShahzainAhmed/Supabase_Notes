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

# Authentication

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

# Google Provider Setup

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

# Database CRUD

## CRUD Meaning

CRUD means:

```text
C → Create
R → Read
U → Update
D → Delete
```

In app terms:

```text
Create → Add new note
Read   → Fetch notes from Supabase
Update → Edit existing note
Delete → Remove note
```

---

# Notes Table

For this topic, a `Notes` table was created in Supabase.

Columns used:

| Column      | Type        | Purpose                    |
| ----------- | ----------- | -------------------------- |
| id          | int8        | Unique note ID             |
| created_at  | timestamptz | Time when note was created |
| title       | text        | Note title                 |
| description | text        | Note description           |

---

# Auto Increment ID

The `id` column automatically increases when a new row is inserted.

Example:

```text
First note  → id = 1
Second note → id = 2
Third note  → id = 3
```

If rows are deleted, IDs may not reset automatically.

Example:

```text
Delete all rows
Next inserted row may still become id = 8
```

This is normal SQL behavior.

IDs are used for uniqueness, not always for perfect counting.

---

# Reset Table ID Counter

If the table is empty and we want the next ID to start from 1 again, use SQL Editor:

```sql
TRUNCATE TABLE "Notes" RESTART IDENTITY;
```

Purpose:

```text
Delete all rows
Reset auto-increment counter
Next inserted row starts from 1
```

---

# Create Note

Create means inserting a new row into the Supabase table.

Code:

```dart
await supabase.from("Notes").insert({
  'title': title.text,
  'description': description.text,
});
```

Meaning:

```text
Go to Notes table
Insert a new row
Save title and description
```

Flow:

```text
User enters title and description
        ↓
Presses Add Note
        ↓
Flutter sends data to Supabase
        ↓
Supabase inserts row in Notes table
```

---

# Add Notes Screen

Purpose:

```text
Take user input
Insert note into Supabase table
Show loading while request is running
```

Important variables:

```dart
final title = TextEditingController();
final description = TextEditingController();
bool isLoading = false;
```

Meaning:

```text
title controller       → reads title TextField value
description controller → reads description TextField value
isLoading              → controls loading indicator
```

Add note function:

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

# Understanding finally

```dart
finally {
  setState(() {
    isLoading = false;
  });
}
```

Meaning:

```text
Run this code no matter what happens.
```

If insert succeeds:

```text
finally still runs
```

If insert fails:

```text
finally still runs
```

Purpose:

```text
Stop loading indicator in both success and error cases
```

---

# Read Notes

Read means fetching rows from Supabase.

Code:

```dart
final result = await supabase.from("Notes").select();
```

Meaning:

```text
Go to Notes table
Fetch all rows
Return data to Flutter
```

Flow:

```text
Home screen opens
        ↓
getNotes() runs
        ↓
Supabase returns notes
        ↓
notes list is updated
        ↓
UI displays ListTiles
```

---

# Storing Fetched Notes

```dart
List notes = [];
```

Purpose:

```text
Store fetched notes locally inside Flutter
```

After fetching:

```dart
setState(() {
  notes = result;
});
```

Meaning:

```text
Save Supabase result into notes list
Rebuild UI
Show latest notes on screen
```

---

# Loading State

```dart
bool isLoading = false;
```

Purpose:

```text
Show loading indicator while data is being fetched
```

Example:

```dart
body: isLoading
    ? Center(child: CircularProgressIndicator())
    : ListView(...)
```

Meaning:

```text
If loading is true  → show spinner
If loading is false → show notes list
```

---

# initState for Fetching Notes

```dart
@override
void initState() {
  getNotes();
  super.initState();
}
```

Purpose:

```text
Fetch notes automatically when HomeScreen opens
```

Important:

```text
initState runs once when screen is created.
```

---

# Display Notes in ListView

Code:

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

Meaning:

```text
Loop through notes list
Create one ListTile for each note
Show title and description
```

---

# Null Safety While Displaying Notes

```dart
note['title'] ?? 'No Title'
```

Meaning:

```text
If title exists, show title
If title is null, show "No Title"
```

Same for description:

```dart
note['description'] ?? 'No Description'
```

---

# Delete Note

Delete means removing a row from the table.

Code:

```dart
await supabase.from("Notes").delete().eq('id', note['id']);
```

Meaning:

```text
Go to Notes table
Delete the row where id equals selected note id
```

Important:

```dart
.eq('id', note['id'])
```

means:

```text
Only delete the note with this specific id.
```

Without `.eq()`:

```text
Delete could affect more rows than expected.
```

---

# Delete Flow

```text
User taps delete icon
        ↓
Flutter sends delete request
        ↓
Supabase finds row by id
        ↓
Supabase deletes that row
```

After deleting, call `getNotes()` again if you want the UI to refresh immediately.

Example:

```dart
await supabase.from("Notes").delete().eq('id', note['id']);

await getNotes();
```

---

# Update Note

Update means editing an existing row.

Code:

```dart
await supabase.from("Notes").update({
  'title': title.text,
  'description': description.text,
}).eq('id', widget.note['id']);
```

Meaning:

```text
Go to Notes table
Update title and description
Only where id equals selected note id
```

---

# Passing Data to Update Screen

From HomeScreen:

```dart
onTap: () => Get.to(
  () => UpdateNotesScreen(note: note),
),
```

Meaning:

```text
User taps note
        ↓
Open UpdateNotesScreen
        ↓
Pass selected note data
```

---

# Update Screen Constructor

```dart
final Map<String, dynamic> note;

const UpdateNotesScreen({
  super.key,
  required this.note,
});
```

Purpose:

```text
Receive selected note from HomeScreen
Use it inside UpdateNotesScreen
```

---

# Pre-Fill TextFields for Update

```dart
@override
void initState() {
  title.text = widget.note['title'] ?? "";
  description.text = widget.note['description'] ?? "";
  super.initState();
}
```

Meaning:

```text
When update screen opens
Put old note title into title TextField
Put old note description into description TextField
```

Purpose:

```text
User can edit existing values instead of typing from empty fields
```

---

# widget.note Meaning

Inside a StatefulWidget State class:

```dart
widget.note
```

means:

```text
Access the note value received by UpdateNotesScreen widget
```

Because `note` belongs to `UpdateNotesScreen`, and the State class accesses it through `widget`.

---

# eq Meaning

```dart
.eq('id', widget.note['id'])
```

`eq` means:

```text
equals to
```

Example:

```text
id equals 5
```

So Supabase updates/deletes only the row where:

```text
id = 5
```

---

# Supabase CRUD Pattern

Create:

```dart
await supabase.from("Notes").insert({...});
```

Read:

```dart
await supabase.from("Notes").select();
```

Update:

```dart
await supabase.from("Notes").update({...}).eq('id', id);
```

Delete:

```dart
await supabase.from("Notes").delete().eq('id', id);
```

---

# Biggest CRUD Learning

```text
from("TableName")
      ↓
Choose action
      ↓
insert / select / update / delete
      ↓
Use eq() when targeting a specific row
```

Example:

```dart
supabase.from("Notes").update({...}).eq('id', noteId);
```

Meaning:

```text
Update Notes table
Only update row where id equals noteId
```

---

# Important Improvement

After adding, updating, or deleting data, the UI may not refresh automatically.

Common solutions:

```text
1. Call getNotes() again
2. Use Get.back(result: true) and refresh after returning
3. Use realtime subscriptions later
```

For beginner CRUD:

```text
Call getNotes() again after delete
Return to HomeScreen and fetch again after add/update
```

---

# Interview Answer

### What is CRUD?

CRUD stands for Create, Read, Update, and Delete. These are the four basic database operations used in most applications. In Supabase, we can perform CRUD using methods like insert, select, update, and delete on a table.

Example:

```text
Create → supabase.from("Notes").insert()
Read   → supabase.from("Notes").select()
Update → supabase.from("Notes").update().eq()
Delete → supabase.from("Notes").delete().eq()
```

---

# Today's Practical Work

Completed:

```text
Created Notes table
Added note from Flutter
Fetched notes from Supabase
Displayed notes in ListTile
Deleted notes by ID
Updated notes by ID
Used loading states
Used initState for initial fetch
Used TextEditingController for form input
Passed note data between screens
```

---

# Row Level Security (RLS)

## What is RLS?

RLS stands for:

```text
Row Level Security
```

It is a Supabase/PostgreSQL security feature used to control which rows a user can:

```text
SELECT
INSERT
UPDATE
DELETE
```

Without RLS, users may access more data than they should.

With RLS, we can control access row by row.

---

# Why RLS is Important

Example:

```text
Ali has 3 notes
Ahmed has 5 notes
Shahzain has 2 notes
```

Without RLS:

```text
Ali might be able to see Ahmed's notes
Ahmed might be able to delete Shahzain's notes
```

With RLS:

```text
Ali can only see Ali's notes
Ahmed can only update Ahmed's notes
Shahzain can only delete Shahzain's notes
```

RLS protects user data at the database level.

---

# Important RLS Concept

When RLS is enabled on a table:

```text
Everything is blocked by default
```

Meaning:

```text
SELECT ❌
INSERT ❌
UPDATE ❌
DELETE ❌
```

until policies are created.

So if notes stop fetching, inserting, updating, or deleting after enabling RLS, it usually means:

```text
Required policy is missing
```

---

# RLS Flow

```text
Flutter sends request
        ↓
Supabase receives request
        ↓
RLS checks policy
        ↓
If policy allows → request succeeds
        ↓
If policy blocks → request fails or returns no data
```

---

# user_id Column

For user-based RLS, the table usually needs a `user_id` column.

Example `Notes` table:

| Column      | Purpose              |
| ----------- | -------------------- |
| id          | Unique note ID       |
| title       | Note title           |
| description | Note description     |
| user_id     | Stores owner user ID |

`user_id` should store:

```dart
supabase.auth.currentUser!.id
```

Example insert:

```dart
await supabase.from("Notes").insert({
  'title': title.text,
  'description': description.text,
  'user_id': supabase.auth.currentUser!.id,
});
```

Meaning:

```text
This note belongs to the currently logged-in user.
```

---

# auth.uid()

In Supabase policies:

```sql
auth.uid()
```

means:

```text
ID of the currently logged-in user
```

Example:

```sql
auth.uid() = user_id
```

Meaning:

```text
Allow this action only if logged-in user ID equals row user_id.
```

---

# SELECT Policy

SELECT policy controls who can read rows.

Example:

```sql
auth.uid() = user_id
```

Meaning:

```text
User can only view rows where user_id matches their own auth ID.
```

Use case:

```text
Show only my notes
Do not show other users' notes
```

---

# INSERT Policy

INSERT policy controls who can create rows.

Example:

```sql
auth.uid() = user_id
```

Meaning:

```text
User can insert a row only if user_id is their own auth ID.
```

Important:

When inserting from Flutter, include:

```dart
'user_id': supabase.auth.currentUser!.id
```

Otherwise insert may fail because the policy condition is not satisfied.

---

# UPDATE Policy

UPDATE policy controls who can edit rows.

Example:

```sql
auth.uid() = user_id
```

Meaning:

```text
User can only update rows that belong to them.
```

Update code:

```dart
await supabase.from("Notes").update({
  'title': title.text,
  'description': description.text,
}).eq('id', widget.note['id']);
```

The `.eq('id', widget.note['id'])` selects the note by ID.

The RLS policy still checks:

```text
Does this note belong to the logged-in user?
```

---

# DELETE Policy

DELETE policy controls who can delete rows.

Example:

```sql
auth.uid() = user_id
```

Meaning:

```text
User can only delete rows that belong to them.
```

Delete code:

```dart
await supabase
    .from("Notes")
    .delete()
    .eq('id', note['id']);
```

The `.eq('id', note['id'])` chooses which note to delete.

The RLS policy checks whether the logged-in user owns that row.

---

# Policies by Operation

| Operation | Supabase Method | Policy Needed |
| --------- | --------------- | ------------- |
| Create    | insert()        | INSERT        |
| Read      | select()        | SELECT        |
| Update    | update()        | UPDATE        |
| Delete    | delete()        | DELETE        |

If one operation stops working after enabling RLS, check whether that policy exists.

Example:

```text
Insert works
Select works
Delete works
Update not working
```

Most likely:

```text
UPDATE policy is missing
```

---

# USING vs WITH CHECK

Some policies ask for:

```text
USING expression
WITH CHECK expression
```

## USING

Used to check existing rows.

Commonly used for:

```text
SELECT
UPDATE
DELETE
```

Example:

```sql
auth.uid() = user_id
```

Meaning:

```text
Can this user access this existing row?
```

## WITH CHECK

Used to check new or changed row data.

Commonly used for:

```text
INSERT
UPDATE
```

Example:

```sql
auth.uid() = user_id
```

Meaning:

```text
Is the new/updated row allowed to be saved?
```

For beginner user-owned data, both can often use:

```sql
auth.uid() = user_id
```

---

# Permissive Policy

Permissive policies behave like an:

```text
OR operator
```

Meaning:

```text
If any permissive policy allows access,
the action is allowed.
```

Example:

```text
Policy 1 allows user because they own the note
OR
Policy 2 allows user because they are admin
```

If either condition is true:

```text
Access allowed
```

---

# Restrictive Policy

Restrictive policies behave like an:

```text
AND operator
```

Meaning:

```text
All restrictive policies must allow access,
otherwise the action is blocked.
```

Example:

```text
User must own the note
AND
User account must be active
AND
Note must not be locked
```

If one condition fails:

```text
Access denied
```

---

# Permissive vs Restrictive

| Policy Type | Logic | Meaning                                 |
| ----------- | ----- | --------------------------------------- |
| Permissive  | OR    | Any one policy can allow access         |
| Restrictive | AND   | All required policies must allow access |

Most beginner apps use:

```text
Permissive policies
```

because they are simpler.

---

# Common Beginner RLS Setup for Notes

For a notes app where each user should only access their own notes:

```text
SELECT → auth.uid() = user_id
INSERT → auth.uid() = user_id
UPDATE → auth.uid() = user_id
DELETE → auth.uid() = user_id
```

Meaning:

```text
Logged-in user can only create, read, update, and delete their own notes.
```

---

# Common RLS Mistakes

## Mistake 1: RLS enabled but no policies

Result:

```text
App cannot read/write data
```

Fix:

```text
Create policies for required operations.
```

## Mistake 2: Missing user_id column

Result:

```text
auth.uid() = user_id policy cannot work
```

Fix:

```text
Add user_id column to table.
```

## Mistake 3: Not inserting user_id from Flutter

Result:

```text
Insert fails or row does not belong to user
```

Fix:

```dart
'user_id': supabase.auth.currentUser!.id
```

## Mistake 4: SELECT works but UPDATE does not

Result:

```text
Update request blocked
```

Fix:

```text
Create UPDATE policy.
```

## Mistake 5: Wrong policy template

Example:

```text
Policy with table joins
```

This is an advanced template.

For simple notes app, use a simple policy like:

```sql
auth.uid() = user_id
```

---

# RLS Interview Answer

### What is RLS in Supabase?

RLS stands for Row Level Security. It controls which rows a user can access in a database table. When RLS is enabled, access is blocked by default unless policies are created. Policies define whether a user can select, insert, update, or delete specific rows.

---

# Why use RLS?

RLS is used to protect user data.

Example:

```text
A user should only see, update, or delete their own notes.
```

Policy:

```sql
auth.uid() = user_id
```

This ensures the logged-in user can only access rows that belong to them.

---

# Biggest RLS Learning

```text
Authentication tells Supabase who the user is.

RLS decides what data that user is allowed to access.
```

Example:

```text
Logged-in user ID
        ↓
auth.uid()
        ↓
Compare with row user_id
        ↓
Allow or block action
```

* Use loading indicators while requests are running
* Use `.eq()` to target a specific row

This completed the basic notes CRUD flow using Flutter and Supabase.
