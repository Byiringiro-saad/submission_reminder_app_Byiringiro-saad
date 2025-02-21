# Individual Lab Summative

This is a basic application that alerts students about upcoming assignment deadlines. 

## Installation

1. Download the script to your local machine
2. Make the script executable:
   ```bash
   chmod +x create_environment.sh
   ```
3. Run the script:
   ```bash
   ./create_environment.sh
   ```

## Setup Process

1. When you run the script, you'll be prompted to enter your name to create a personalized workspace
2. The script will create a new directories with the following components:
   - `app/`: Contains reminder script
   - `modules/`: Contains functions script
   - `assets/`: Stores submission data
   - `config/`: Contains configuration file
3. This is the folder structure
   ```
    submission_reminder_[your_name]/
    ├── app/
    │   └── reminder.sh
    ├── modules/
    │   └── functions.sh
    ├── assets/
    │   └── submissions.txt
    ├── config/
    │   └── config.env
    └── startup.sh
    ```

## Initial Configuration

The workspace comes with pre-configured settings in `config/config.env`:
- Default course name: "Shell Navigation"
- Default deadline: 3 days

You can modify these settings by editing the config file directly.

## Adding Student Records

During setup, you'll be prompted to add student records with the following information:
- Student name
- Course name (choose from):
  - Shell Navigation
  - Git
  - Shell Basics
- Submission status:
  - submitted
  - not submitted

## Usage

1. After running the script, Navigate to your workspace directory:
   ```bash
   cd submission_reminder_[your_name]
   ```

2. Run the system:
   ```bash
   ./startup.sh
   ```
   
## Author

Created by Byiringiro Saad
