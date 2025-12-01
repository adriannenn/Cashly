# Cashly API Documentation

## Overview

This document describes the RESTful API endpoints for the Cashly budget tracking application. The API follows standard HTTP methods and returns JSON responses.

**Base URL:** `https://api.cashly.com/v1`

## Authentication

All authenticated endpoints require a Bearer token in the Authorization header:

\`\`\`
Authorization: Bearer {token}
\`\`\`

### POST /auth/login
Login with email and password.

**Request Body:**
\`\`\`json
{
  "email": "user@example.com",
  "password": "password123"
}
\`\`\`

**Response (200 OK):**
\`\`\`json
{
  "success": true,
  "user": {
    "id": "user_id",
    "fullName": "John Doe",
    "email": "user@example.com"
  },
  "token": "jwt_token_here"
}
\`\`\`

### POST /auth/register
Register a new user account.

**Request Body:**
\`\`\`json
{
  "full_name": "John Doe",
  "email": "user@example.com",
  "password": "password123"
}
\`\`\`

**Response (201 Created):**
\`\`\`json
{
  "success": true,
  "user": {
    "id": "user_id",
    "fullName": "John Doe",
    "email": "user@example.com"
  },
  "token": "jwt_token_here"
}
\`\`\`

## Budgets

### GET /budgets
Get all budgets for authenticated user.

**Query Parameters:**
- `user_id` (required): User ID

**Response (200 OK):**
\`\`\`json
{
  "success": true,
  "budgets": [
    {
      "id": "budget_id",
      "userId": "user_id",
      "name": "Monthly Groceries",
      "amount": 500.00,
      "category": "Food & Dining",
      "period": "monthly",
      "startDate": "2025-01-01T00:00:00Z",
      "endDate": "2025-01-31T23:59:59Z",
      "description": "Monthly grocery budget"
    }
  ]
}
\`\`\`

### POST /budgets
Create a new budget.

**Request Body:**
\`\`\`json
{
  "userId": "user_id",
  "name": "Monthly Groceries",
  "amount": 500.00,
  "category": "Food & Dining",
  "period": "monthly",
  "startDate": "2025-01-01T00:00:00Z",
  "endDate": "2025-01-31T23:59:59Z",
  "description": "Monthly grocery budget"
}
\`\`\`

**Response (201 Created):**
\`\`\`json
{
  "success": true,
  "budget": {
    "id": "budget_id",
    "userId": "user_id",
    "name": "Monthly Groceries",
    "amount": 500.00,
    "category": "Food & Dining",
    "period": "monthly",
    "startDate": "2025-01-01T00:00:00Z",
    "endDate": "2025-01-31T23:59:59Z",
    "description": "Monthly grocery budget"
  }
}
\`\`\`

### PUT /budgets/:id
Update an existing budget.

**Request Body:**
\`\`\`json
{
  "name": "Monthly Groceries Updated",
  "amount": 600.00
}
\`\`\`

**Response (200 OK):**
\`\`\`json
{
  "success": true,
  "budget": {
    "id": "budget_id",
    "name": "Monthly Groceries Updated",
    "amount": 600.00
  }
}
\`\`\`

### DELETE /budgets/:id
Delete a budget.

**Response (200 OK):**
\`\`\`json
{
  "success": true,
  "message": "Budget deleted successfully"
}
\`\`\`

## Transactions

### GET /transactions
Get all transactions for authenticated user.

**Query Parameters:**
- `user_id` (required): User ID
- `type` (optional): Filter by type (income/expense)
- `start_date` (optional): Filter by start date
- `end_date` (optional): Filter by end date

**Response (200 OK):**
\`\`\`json
{
  "success": true,
  "transactions": [
    {
      "id": "transaction_id",
      "userId": "user_id",
      "type": "expense",
      "amount": 50.00,
      "category": "Food & Dining",
      "title": "Grocery Shopping",
      "note": "Weekly groceries",
      "date": "2025-01-15T10:30:00Z"
    }
  ]
}
\`\`\`

### POST /transactions
Create a new transaction.

**Request Body:**
\`\`\`json
{
  "userId": "user_id",
  "type": "expense",
  "amount": 50.00,
  "category": "Food & Dining",
  "title": "Grocery Shopping",
  "note": "Weekly groceries",
  "date": "2025-01-15T10:30:00Z"
}
\`\`\`

**Response (201 Created):**
\`\`\`json
{
  "success": true,
  "transaction": {
    "id": "transaction_id",
    "userId": "user_id",
    "type": "expense",
    "amount": 50.00,
    "category": "Food & Dining",
    "title": "Grocery Shopping",
    "note": "Weekly groceries",
    "date": "2025-01-15T10:30:00Z"
  }
}
\`\`\`

### PUT /transactions/:id
Update an existing transaction.

**Request Body:**
\`\`\`json
{
  "amount": 55.00,
  "title": "Grocery Shopping Updated"
}
\`\`\`

**Response (200 OK):**
\`\`\`json
{
  "success": true,
  "transaction": {
    "id": "transaction_id",
    "amount": 55.00,
    "title": "Grocery Shopping Updated"
  }
}
\`\`\`

### DELETE /transactions/:id
Delete a transaction.

**Response (200 OK):**
\`\`\`json
{
  "success": true,
  "message": "Transaction deleted successfully"
}
\`\`\`

## Analytics

### GET /analytics
Get financial analytics for authenticated user.

**Query Parameters:**
- `user_id` (required): User ID
- `period` (optional): Time period (week/month/year)

**Response (200 OK):**
\`\`\`json
{
  "success": true,
  "analytics": {
    "totalIncome": 5000.00,
    "totalExpense": 3500.00,
    "balance": 1500.00,
    "expensesByCategory": {
      "Food & Dining": 800.00,
      "Transportation": 400.00,
      "Shopping": 300.00
    },
    "incomeByCategory": {
      "Salary": 5000.00
    }
  }
}
\`\`\`

## Sync

### POST /sync
Sync local data with server.

**Request Body:**
\`\`\`json
{
  "user_id": "user_id",
  "budgets": [...],
  "transactions": [...]
}
\`\`\`

**Response (200 OK):**
\`\`\`json
{
  "success": true,
  "message": "Data synced successfully",
  "synced_at": "2025-01-15T12:00:00Z"
}
\`\`\`

## Error Responses

All endpoints may return the following error responses:

### 400 Bad Request
\`\`\`json
{
  "success": false,
  "error": "Invalid request parameters"
}
\`\`\`

### 401 Unauthorized
\`\`\`json
{
  "success": false,
  "error": "Authentication required"
}
\`\`\`

### 404 Not Found
\`\`\`json
{
  "success": false,
  "error": "Resource not found"
}
\`\`\`

### 500 Internal Server Error
\`\`\`json
{
  "success": false,
  "error": "Internal server error"
}
\`\`\`

## Rate Limiting

API requests are limited to 100 requests per minute per user. Exceeding this limit will result in a 429 Too Many Requests response.

## Data Validation

All API endpoints validate input data according to the following rules:
- Email: Valid email format
- Password: Minimum 6 characters
- Amount: Positive number
- Budget name: Maximum 50 characters
- Transaction title: Required field
- Dates: Valid ISO 8601 format
