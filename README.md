# Expatrio Coding Challenge

## Overview

This project is a coding challenge solution for Expatrio. It includes implementations for API service, data models, and providers for managing user tax data.

## Installation

To use this project, follow these steps:

1. Clone the repository: `git clone https://github.com/your/repository.git`
2. Navigate to the project directory: `cd expatrio_coding_challenge`
3. Install dependencies: `flutter pub get`

## Usage

To use the project, import it into your Flutter application and utilize the provided classes and methods. Here's a brief overview:

- `ExpatrioApiService`: Handles API requests for user authentication and tax data management.
- `UserTaxData`: Model class for representing user tax data.
- `UserTaxDataProvider`: Provider class for managing user tax data locally in the application.

## API

- login(email: String, password: String): Logs in the user with the provided email and password and returns user ID and access token.
- getUserTaxData(userId: int, accessToken: String): Retrieves user tax data for the given user ID and access token.
- updateTaxData(userId: int, accessToken: String, updatedTaxData: UserTaxData): Updates user tax data for the given user ID and access token.

## Running Tests

To run the tests, execute the following command:

```
flutter test

```
