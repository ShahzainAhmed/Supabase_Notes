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
