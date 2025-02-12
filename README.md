# New Hires App

## Overview

This iOS app displays information about new hires and keeping track of your todo's. It fetches data from a remote server, handles local persistence, and provides user-friendly error handling and UI states (loading, success, error, and empty).

---

## Features

- Display new hire information (name, start date, avatar).
- Keeping track of and interacting with to do's
- Handle network errors with retry functionality.
- Show custom empty state when no new hires or to do's are available.
- Sync data with the server while managing local storage.

---

## Architecture

- **MVVM**: The app uses the Model-View-ViewModel architecture.
- **Networking**: Data is fetched using `URLSession` and synced with the server.
- **Persistence**: Local data storage is handled using SwiftData.

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/KCordilia/AppicalAssessment.git
