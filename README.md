# PG Mate - Paying Guest Management System

Full-stack web app for managing PG (Paying Guest) accommodations. Owners can list PGs, manage rooms/tenants/payments; tenants can browse, book, and pay rent.

## Prerequisites

- **Java 17+** (JDK installed, `java -version` works)
- **MySQL 8.0+** (running on `localhost:3306`)
- **Maven** (wrapper included — use `mvnw.cmd`)

## Quick Start

### 1. Create the database

Run once (or use the SQL file manually):

```
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS sy_project_pgmate CHARACTER SET utf8mb4;"
```

### 2. Update credentials (if needed)

Edit `src/main/resources/application.properties` and change `username`/`password` if your MySQL root password differs.

### 3. Start the app

```bash
.\mvnw.cmd spring-boot:run
```

The app will:
- Auto-create/update all tables via Hibernate
- Seed default amenities (WiFi, AC, Food, etc.)
- Start on **http://localhost:8081**

### 4. Open the app

Visit **http://localhost:8081** in your browser.

## Project Structure

```
Backend/demo/
├── src/main/java/com/PGMATE/demo/
│   ├── model/          # JPA entities (User, Pg, Room, Booking, etc.)
│   ├── repository/     # Spring Data JPA repositories
│   ├── controller/     # REST API controllers
│   ├── dto/            # Data transfer objects
│   └── config/         # Spring Security config
├── src/main/resources/
│   ├── application.properties   # Database & server config
│   ├── data.sql                 # Auto-seed data (runs on startup)
│   └── static/Frontend/         # HTML/CSS/JS frontend
├── database.sql                 # Full schema script (reference)
└── pom.xml
```

## API Endpoints

All at `http://localhost:8081/api`

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST   | /auth/register | Register user |
| POST   | /auth/login | Login |
| GET    | /pgs | List all PGs |
| GET    | /pgs/{id} | Get PG details |
| GET    | /rooms/pg/{pgId} | Rooms for a PG |
| POST   | /rooms | Create room |
| POST   | /bookings | Request booking |
| GET    | /bookings/owner/{id} | Owner's bookings |
| PUT    | /bookings/{id} | Approve/Reject booking |
| POST   | /payments/record | Record payment |
| POST   | /feedbacks | Submit feedback |
| GET    | /amenities | List amenities |
| POST   | /notifications | Send rent reminder |

## Sharing this project

After zipping, the recipient just needs to:

1. Install Java 17+ and MySQL 8+
2. Run `mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS sy_project_pgmate;"`
3. Run `.\mvnw.cmd spring-boot:run` inside `Backend/demo/`
4. Open **http://localhost:8081**
