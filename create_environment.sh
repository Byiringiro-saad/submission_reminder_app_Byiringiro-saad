#!/bin/bash

# Validate that input contains only permitted characters
sanitize_input() {
    if [[ "$1" =~ [^a-zA-Z0-9_] ]]; then
        echo "⚠️  Invalid input: Please use only alphanumeric characters and underscores"
        return 1
    fi
    return 0
}

# Initialize interface with ASCII art header
clear
cat << "EOF"
╔════════════════════════════════════════════╗
║        HOMEWORK PROGRESS TRACKER           ║
║       Created by - Byiringiro Saad -       ║
╚════════════════════════════════════════════╝
EOF

# Get teacher's identifier
while true; do
    echo -n "🎓 Enter your name for workspace creation: "
    read teacher_id
    
    if sanitize_input "$teacher_id"; then
        break
    fi
done

# Set up workspace directory
workspace_dir="submission_reminder_${teacher_id}"
echo -e "\n📁 Initializing workspace in $workspace_dir..."

if [ -d "$workspace_dir" ]; then
    echo "⚠️  Workspace already exists!"
    echo -n "🔄 Recreate workspace? (y/n): "
    read choice
    if [ "$choice" != "y" ] && [ "$choice" != "Y" ]; then
        echo "❌ Setup cancelled"
        exit 1
    fi
    rm -rf "$workspace_dir"
    echo "🗑️  Old workspace cleared"
fi

# Create directory structure
mkdir -p "$workspace_dir"/{app,modules,assets,config}
echo "✅ Created workspace structure"

# Generate config file
cat > "$workspace_dir/config/config.env" << 'EOF'
# Environment Configuration
COURSE_NAME="Shell Navigation"
DEADLINE_DAYS=3
EOF
echo "✅ Generated config file"

# Create functions file
cat > "$workspace_dir/modules/functions.sh" << 'EOF'
#!/bin/bash

source ./config/config.env

# Process student submission status
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$COURSE_NAME" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $COURSE_NAME assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF
echo "✅ Created functions script"

# Create remider file
cat > "$workspace_dir/app/reminder.sh" << 'EOF'
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $COURSE_NAME"
echo "Days remaining to submit: $DEADLINE_DAYS days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF
echo "✅ Created reminder script"

# Initialize submissions file
cat > "$workspace_dir/assets/submissions.txt" << 'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
EOF

# Display available courses and statuses
echo -e "\n📋 Available Courses:"
echo "🔸 Git"
echo "🔸 Shell Basics"
echo "🔸 Shell Navigation"

echo -e "\n📊 Available Statuses:"
echo "✅ submitted"
echo "❌ not submitted"

# Add more student records
echo -e "\n📝 Please add 5 more student records"

for i in {1..5}; do
    echo -e "\n👤 Student #$i:"
    
    echo -n "Student name: "
    read student_name
    
    echo -n "Course name (Shell Navigation/Git/Shell Basics): "
    read course_name
    
    # Validate course name
    while [[ "$course_name" != "Shell Navigation" && "$course_name" != "Git" && "$course_name" != "Shell Basics" ]]; do
        echo "⚠️  Invalid course! Please choose from the available courses"
        echo -n "Course name (Shell Navigation/Git/Shell Basics): "
        read course_name
    done
    
    echo -n "Status (submitted/not submitted): "
    read submission_status
    
    # Validate status
    while [[ "$submission_status" != "submitted" && "$submission_status" != "not submitted" ]]; do
        echo "⚠️  Invalid status! Use 'submitted' or 'not submitted'"
        echo -n "Status (submitted/not submitted): "
        read submission_status
    done
    
    echo "$student_name, $course_name, $submission_status" >> "$workspace_dir/assets/submissions.txt"
    echo "✅ Added $student_name's record"
done

# Create startup script
cat > "$workspace_dir/startup.sh" << 'EOF'
#!/bin/bash

echo "╔════════════════════════════════════════════╗"
echo "║      HOMEWORK SUBMISSION MONITOR           ║"
echo "╚════════════════════════════════════════════╝"

# Verify system integrity
for file in "./config/config.env" "./modules/functions.sh" "./app/reminder.sh" "./assets/submissions.txt"; do
    if [ ! -f "$file" ]; then
        echo "❌ Error: Missing $file"
        exit 1
    fi
done

# Ensure execution permissions
chmod +x ./app/reminder.sh
./app/reminder.sh

echo
echo "✨ Monitoring complete"
EOF

# Set execution permissions
chmod +x "$workspace_dir/app/reminder.sh" "$workspace_dir/modules/functions.sh" "$workspace_dir/startup.sh"
echo "✅ Set execution permissions"

echo -e "\n🎉 Setup complete! Your workspace is ready in '$workspace_dir'"
echo -e "▶️  To start monitoring, run:\n"
echo "cd $workspace_dir && ./startup.sh"