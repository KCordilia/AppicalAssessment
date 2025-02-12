# New Hires App

## Overview

This iOS app helps manage and display information about new hires. It fetches data from a remote server, handles local persistence, and provides user-friendly error handling and UI states (loading, success, error, and empty).

---

## Features

- Display new hire information (name, start date, avatar).
- Handle network errors with retry functionality.
- Show custom empty state when no new hires are available.
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
   git clone <your-repository-url>
