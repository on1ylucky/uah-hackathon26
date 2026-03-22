# StudyLock

StudyLock is a productivity application that transforms screen time into earned time. Instead of passively blocking distractions, users must actively engage with study material to unlock access to their apps.

---

## Overview

Most productivity tools rely on timers or restrictions to limit app usage. While effective in the short term, these methods do not promote long-term engagement or meaningful learning.

StudyLock introduces a different approach:
- Users earn access to apps by answering questions
- Learning becomes a prerequisite for entertainment
- Distractions are reframed as incentives

---

## Motivation

The project is based on a common challenge: people want to be productive, but distractions are always available.

Rather than removing distractions entirely, StudyLock leverages them:
- Opening a distracting app requires completing study tasks
- Screen time is earned through active effort

This creates a system where:
- productivity is rewarded
- learning becomes consistent
- habits are reinforced through repetition

---

## Features

### App Locking System
- Lock apps behind study requirements
- Configure:
  - number of required questions
  - difficulty level
  - associated study set

---

### Study Sets
- Create and manage custom study sets
- Add, edit, and delete questions
- Assign difficulty levels:
  - Easy
  - Medium
  - Hard
- Supports:
  - Multiple choice
  - Typed answer

---

### Gamified Progress System
- XP accumulation
- Level progression
- Streak tracking
- Time bank for earned usage

---

### Stats and Feedback
- Tracks accuracy and completion
- Provides insight into performance
- Encourages improvement over time

---

### Daily Engagement
- Random motivational quote (updates on each app launch)
- Question of the Day (updates once per day)
- Designed to encourage interaction and continued use

---

### Simulation Mode
- Demonstrates the app unlocking process
- Simulates restricted app behavior
- Requires answering questions before continuing

---

## Implementation

StudyLock is built using:

- SwiftUI for interface and layout
- Combine and ObservableObject for state management
- Local data structures for study sets, progress tracking, and app rules

The current implementation focuses on:
- core functionality
- user interaction flow
- simulation of app restriction and unlocking

---

## Future Work

- Integration with Apple Screen Time APIs for real app control
- Adaptive learning system based on user performance
- Social features and shared prompts
- AI-generated study content from notes or documents

---

## Key Idea

StudyLock redefines productivity by shifting the focus from restriction to engagement.

Instead of blocking distractions, it requires users to earn access through learning. This creates a system where productivity is directly tied to user behavior, making it both effective and sustainable.

---

## Author

Emi Swinford  
Cybersecurity, University of Alabama in Huntsville
