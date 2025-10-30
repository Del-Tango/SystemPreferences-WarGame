# System Preferences WarGame

A Linux command-line wargame designed to teach system administration and security concepts through hands-on challenges.

## Overview

System Preferences is an interactive learning game that guides players through various Linux system administration tasks across multiple levels. Each level introduces new concepts and challenges that build upon previous knowledge, creating a progressive learning experience.

## Game Structure

### Levels & Chapters

The game is organized into 8 main levels, each containing multiple chapters:

- Level 0: File System Navigation (6 chapters)
- Level 1: File Handling (5 chapters)
- Level 2: Process Management (2 chapters)
- Level 3: File Editing (2 chapters)
- Level 4: Cron Jobs (2 chapters)
- Level 5: Networking (4 chapters)
- Level 6: UNIX Services (3 chapters)
- Level 7: Scripting (2 chapters)
- Level 8: Final Puzzle & Q/A Test

## Game Features

- Progressive Difficulty: Starts with basic commands and advances to complex system administration tasks
- Interactive Validation: Each chapter includes validation scripts to verify completion
- User Isolation: Separate user accounts for each level with escalating privileges
- Educational Focus: Teaches practical Linux skills through hands-on challenges
- Story-driven: Engaging narrative to maintain player interest

### Installation

Quick Start
```bash
./setup.sh
```

### Manual Setup

The setup script will:

- Install required dependencies
- Create level-specific user accounts
- Set up challenge environments
- Configure game controllers and validators
- Initialize the game state

### Game Commands

Core Commands
```bash
game help          # Display help message
game level         # Show current level
game chapter       # Show current chapter
game submit [data] # Submit solution for current challenge
game skip <target> <number> # Skip to specific level or chapter
```

Skip Examples
```bash
game skip level 3    # Skip to level 3
game skip chapter 2  # Skip to chapter 2 of current level
```

### Learning Path

#### Level 0: File System Navigation

- Basic directory navigation
- File listing and discovery
- Hidden files and special directories
- File search and location

#### Level 1: File Handling

- File manipulation (move, copy, rename)
- File permissions and ownership
- Directory management
- Batch file operations

#### Level 2: Process Management

- Process monitoring and identification
- Process termination
- Process priority management
- Background processes

#### Level 3: File Editing

- Text editors (vim, nano)
- File content manipulation
- Stream editing with sed/awk

#### Level 4: Cron Jobs

- Scheduling tasks with crontab
- Automation scripts
- Job management

#### Level 5: Networking

- Network connections with netcat
- Port scanning and service discovery
- Basic web server setup
- Network troubleshooting

#### Level 6: UNIX Services

- Service management (systemctl, service)
- SSH service control
- Daemon processes

#### Level 7: Scripting

- Bash scripting fundamentals
- Loop structures and conditionals
- Network scripting
- Process automation

#### Level 8: Final Assessment

- Comprehensive Q/A test
- Knowledge verification
- Final puzzle challenge

## Technical Details

### File Structure
```text
/
├── setup.sh                 # Main installation script
├── conf/setup.conf          # Configuration file
├── src/
│   ├── controllers/         # Game control logic
│   ├── installers/         # Level setup scripts
│   └── validators/         # Challenge validation
├── data/                   # Game banners and content
└── cargo/                  # Additional game components
```

### User Accounts

The game creates dedicated users for each level:

- Ghost (Level 0)
- Ghost-1 through Ghost-8 (Levels 1-8)

Each user has their own home directory and specific permissions appropriate for their level's challenges.

## Educational Value

This game teaches practical skills in:

- Linux command-line proficiency
- System administration tasks
- Security fundamentals
- Problem-solving methodology
- Scripting and automation

## Requirements

- Linux environment (tested on Ubuntu/Debian)
- Bash shell
- Standard GNU utilities
- Root access (for initial setup)

## Troubleshooting

If you encounter issues:

- Ensure all dependencies are installed
- Verify the setup script completed successfully
- Check file permissions in game directories
- Confirm user accounts were created properly


System Preferences is designed to help learners develop practical Linux system administration skills through hands-on challenges in a safe, controlled environment. Created for security training and skill development.

Regards, the Alveare Solutions #!/Society
