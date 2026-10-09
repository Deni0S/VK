# VKontakte
[![Status](https://img.shields.io/badge/status-deprecated-red)](#)
[![Purpose](https://img.shields.io/badge/purpose-educational%20%2F%20history-blue)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](./LICENSE)
[![Year](https://img.shields.io/badge/year-2020-lightgrey)](#)

> **This project is no longer maintained.**
> It is kept as an educational subproject for reference and historical purposes.
> The code may be incomplete, outdated, or contain educational simplifications.

A **VKontakte** client that connects to **VK API** services and provides access to the main features of the social network: feed, messages, profile, friends, communities. The architecture is built on a **client–server approach**: the client sends requests, the VK server processes them and returns data.

## Features

- 📰 **News feed** — posts from friends and communities
- 💬 **Messages** — dialogs and real-time chats
- 👤 **Profile** — personal info, avatar, status
- 👥 **Friends** — list, search, online status
- 🏘️ **Communities** — groups and public pages
- 🔍 **Search** — by people, communities, posts

## Architecture

### Client–Server

The application works on a **client ↔ server** scheme:

1. The client sends a request to **VK API**.
2. The VK server processes the request and returns a response.
3. The client processes the data and displays it to the user.

All requests go through a **service layer** responsible for authorization, retries, and error handling.

### Data Processing

- Parsing VK API responses (JSON → models)
- Filtering and sorting data
- Caching for offline access
- Asynchronous loading of images and media

### Transition

- Smooth navigation between screens
- Custom transitions (push, modal, fade)
- Interactive "back" gestures
- Syncing animations with the screen lifecycle

### Animation / Animated

- Animated transitions and element appearances
- Animation of likes, reposts, comments
- Spring and smooth curves (spring, ease-in-out)
- Animated loading indicators

### NotificationCenter

Notification center for exchanging events within the app:

- Data change notifications
- Reaction to authorization events
- State synchronization between modules
- Decoupling components via `NotificationCenter`

### Realm

Local data storage:

- Caching posts, messages, profiles
- Offline access to previously loaded data
- Fast read and write
- Synchronization with data from VK API

### VKAPI

Layer for interacting with VKontakte services:

- OAuth authorization
- Requests to VK API methods (`users.get`, `wall.get`, `messages.get`)
- Error handling and retries
- Rate limiting