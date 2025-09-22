#!/bin/bash

# =====================================================
# 🏴‍☠️ CAPTAIN SHELLBEARD'S SECURE TREASURE HUNT 🏴‍☠️
# Version: 3.0 - Anti-Cheat Security Edition
# Students CANNOT access this source code!
# =====================================================

# Color codes for dramatic effect
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# Generate unique session ID for tracking and security
SESSION_ID="$(date +%s)_$(whoami)_$$"
BASE_DIR="$HOME/shellbeard_adventure"
QUEST_LOG="$BASE_DIR/quest.log"

# ASCII Art for drama
print_welcome_banner() {
    clear
    echo -e "${CYAN}${BOLD}"
    cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║    🏴‍☠️ CAPTAIN SHELLBEARD'S LOST ARCHIVES 🏴‍☠️                  ║
║                                                              ║
║         "The terminals remember what files forget"           ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo -e "${GREEN}Ahoy, brave digital explorer!${NC}"
    echo -e "${YELLOW}You're about to embark on the most challenging Linux command quest ever created!${NC}"
    echo ""
    echo -e "${PURPLE}Your mission: Find Captain Shellbeard's legendary Golden Penguin${NC}"
    echo -e "${PURPLE}Your tools: Only the command line and your wit${NC}"
    echo ""
    read -p "Press ENTER to begin your adventure..."
}

# Create the secure quest environment
initialize_quest() {
    echo -e "\n${CYAN}🔧 Preparing your personal quest environment...${NC}"
    
    # Clean slate - remove any previous attempts
    if [ -d "$BASE_DIR" ]; then
        echo -e "${YELLOW}⚠️  Found previous adventure. Starting fresh...${NC}"
        rm -rf "$BASE_DIR"
    fi
    
    mkdir -p "$BASE_DIR"
    cd "$BASE_DIR"
    
    # Initialize quest log with security tracking
    cat > "$QUEST_LOG" << EOF
🏴‍☠️ CAPTAIN SHELLBEARD'S TREASURE HUNT LOG 🏴‍☠️
=====================================================
Quest ID: $SESSION_ID
Adventurer: $(whoami)
Started: $(date)
System: $(uname -s)
Shell: $SHELL
=====================================================

EOF
    
    echo -e "${GREEN}✅ Quest environment secured and ready!${NC}"
}

# Challenge 1: Command Temple - Fixed Navigation Issues
create_command_temple() {
    echo -e "${BLUE}🏛️  Building the Command Temple...${NC}"
    
    # Create clear, memorable folder structure (NO TIMESTAMPS!)
    mkdir -p island/{beach,jungle,cave,mountain/{peak,base},river}
    
    # Beach welcome and hidden scroll
    cat > island/beach/welcome.txt << 'EOF'
🏖️ WELCOME TO THE MYSTERIOUS ISLAND! 🏖️

You've washed ashore after your ship was wrecked in a digital storm.
Captain Shellbeard's treasure is hidden somewhere on this island!

🎯 YOUR FIRST CHALLENGE:
Find the hidden scroll that contains the first piece of the treasure map!

💡 HINT: Some files like to hide... they start with a special character.
Use 'ls -la' to see ALL files, including hidden ones!

Commands you'll need:
- pwd (where am I?)
- ls (what's here?)  
- ls -la (show hidden files too!)
- cat filename (read a file)
EOF

    # The actual first clue - CLEARLY leads to jungle
    cat > island/beach/.hidden_scroll << 'EOF'
🗞️ FIRST CLUE FOUND! 

"Where pirates once made camp among the trees,
Four fragments of a map drift in the breeze.
The JUNGLE holds these pieces torn apart,
Combine them well to find where next to start!"

📍 CLEAR DIRECTION: Go to the jungle folder
💡 Command: cd ../jungle
🎯 Mission: Look for map pieces and combine them!

Captain Shellbeard's First Clue ✓
EOF

    # Log progress
    echo "$(date): Command Temple created - Beach and hidden scroll ready" >> "$QUEST_LOG"
}

# Challenge 2: Directory Maze - Fixed File Operations  
create_directory_maze() {
    echo -e "${GREEN}📁 Constructing the Directory Maze...${NC}"
    
    cd island/jungle
    
    # Create map pieces that form a CLEAR visual when combined
    echo "╔═══════════════╗" > map_piece_1.txt
    echo "║  🏴‍☠️ TREASURE MAP  ║" > map_piece_2.txt  
    echo "║      ⬇️        ║" > map_piece_3.txt
    echo "║    TO CAVE     ║" > map_piece_4.txt
    echo "╚═══════════════╝" > map_piece_5.txt
    
    # Instructions that teach file operations
    cat > jungle_guide.txt << 'EOF'
🌿 WELCOME TO THE JUNGLE! 🌿

You've found the pirate camp! The ancient map has been torn into pieces.

🎯 YOUR CHALLENGE:
1. List all map pieces: ls map_piece*
2. Combine them in order: cat map_piece_*.txt > complete_map.txt  
3. View your assembled map: cat complete_map.txt
4. Count the lines: wc -l complete_map.txt (answer should be 5)
5. Make a backup: cp complete_map.txt map_backup.txt

When you see where the map points, you'll know where to go next!
EOF

    # The reward clue - CLEARLY points to cave
    cat > .jungle_secret << 'EOF'
🗺️ MAP ASSEMBLED SUCCESSFULLY!

Your complete map shows an arrow pointing to the CAVE!
This is where the pirate's diary reveals the next secret.

📍 CLEAR DIRECTION: Navigate to the cave  
💡 Command: cd ../cave
🎯 Mission: Find and search the pirate's diary for "golden" clues!

Captain Shellbeard's Second Clue ✓
EOF

    echo "$(date): Directory Maze created - Map fragments ready in jungle" >> "$QUEST_LOG"
}

# Challenge 3: Search Sanctum - Fixed grep patterns
create_search_sanctum() {
    echo -e "${PURPLE}🔍 Preparing the Search Sanctum...${NC}"
    
    cd ../cave
    
    # Create a detailed pirate diary with CLEAR golden references
    cat > pirates_diary.txt << 'EOF'
🏴‍☠️ CAPTAIN REDBEARD'S DIARY 🏴‍☠️

Day 1: Began searching for the legendary golden treasure of the ancients
Day 2: Found silver coins today, but they're not the golden prize I seek  
Day 3: The golden compass points toward the mountain - could it be there?
Day 4: Discovered a cache of golden doubloons, getting warmer!
Day 5: The waterfall near the mountain echoes with mysterious sounds
Day 6: Found a golden key hidden at the mountain's base - very promising!
Day 7: SUCCESS! Located the golden penguin statue - this must be it!
Day 8: Beware of fool's gold - only the true golden treasure matters
Day 9: The mountain base seems to be haunted by strange spirits
Day 10: Final treasure confirmed: the golden penguin awaits brave souls
EOF

    # Clear instructions for searching
    cat > cave_instructions.txt << 'EOF'
🕯️ WELCOME TO THE MYSTERIOUS CAVE! 🕯️

You've found Captain Redbeard's personal diary from decades ago!
He was also searching for the golden penguin treasure!

🎯 YOUR CHALLENGE:
1. Search for "golden": grep golden pirates_diary.txt
2. Count golden mentions: grep -c golden pirates_diary.txt (should be 8)
3. Find the penguin day: grep penguin pirates_diary.txt (Day 7!)
4. Search multiple words: grep -E "golden|mountain" pirates_diary.txt

The diary reveals the golden penguin's location and your next destination!
EOF

    # The next clue - CLEARLY points to mountain base
    cat > .cave_secret << 'EOF'
📖 DIARY SECRETS REVEALED!

Day 7 mentions the GOLDEN PENGUIN - your ultimate target!
The diary also mentions the MOUNTAIN BASE multiple times.
Captain Redbeard found a golden key there!

📍 CLEAR DIRECTION: Go to the mountain base
💡 Command: cd ../mountain/base  
🎯 Mission: Defeat the ghost pirate process that haunts that location!

Captain Shellbeard's Third Clue ✓
EOF

    echo "$(date): Search Sanctum created - Diary with clear golden references" >> "$QUEST_LOG"
}

# Challenge 4: Process Pyramid - FIXED PID ISSUES!
create_process_pyramid() {
    echo -e "${RED}⚙️  Raising the Process Pyramid...${NC}"
    
    cd ../mountain/base
    
    # Create DYNAMIC ghost process system (fixes PID mismatch issue!)
    cat > ghost_challenge.txt << 'EOF'
👻 THE GHOST PIRATE CHALLENGE 👻

A ghost pirate process haunts this mountain base!
You must banish it to proceed on your quest.

🎯 YOUR CHALLENGE:
1. Start the ghost: ./summon_ghost.sh
2. Find the ghost process: ps aux | grep "ghost_pirate"  
3. Or use: ps aux | grep sleep
4. Note the PID (Process ID number)
5. Banish the ghost: kill [PID]
6. Verify it's gone: ps aux | grep "ghost_pirate"

The ghost_info.txt file will show you the current PID!
EOF

    # Create the ghost summoning script - FIXES PID ISSUES
cat > summon_ghost.sh << 'EOF'
#!/bin/bash
echo "🌫️ Summoning the ancient mountain ghost..."
echo ""

# Clean up any existing ghosts
pkill -f "mountain_ghost_eternal" 2>/dev/null
sleep 1

# Function to handle ghost banishment
banish_ghost() {
    echo ""
    echo "🧙‍♂️ The ancient rites have been performed..."
    echo "💨 The mountain ghost has been banished from this realm!"
    echo "🪦 Rest in peace, PID: $GHOST_PID"
    exit 0
}

# Trap SIGINT and SIGTERM to banish ghost gracefully
trap banish_ghost SIGINT SIGTERM

# Create the ghost process with unique signature visible in ps
bash -c 'while true; do echo "mountain_ghost_eternal_$(date +%s)" > /dev/null; sleep 3; done' &

GHOST_PID=$!
echo "👻 MOUNTAIN GHOST AWAKENED!"
echo "Ghost Process ID: $GHOST_PID" > ghost_process_info.txt
echo "Process Signature: mountain_ghost_eternal" >> ghost_process_info.txt
echo "Summoned: $(date)" >> ghost_process_info.txt

echo "💀 A digital spirit now haunts the mountain with PID: $GHOST_PID"
echo "📋 Ghost details saved to: ghost_process_info.txt"
echo ""
echo "⚔️ TO BANISH THE GHOST:"
echo "   1. Find it: ps aux | grep mountain_ghost_eternal"
echo "   2. Destroy it: kill $GHOST_PID"
echo "   3. Verify victory: ps aux | grep mountain_ghost_eternal"
echo ""
echo "🏴‍☠️ May your process control skills prove strong, brave warrior!"

# Wait for ghost process to be killed
wait $GHOST_PID
banish_ghost
EOF

chmod +x summon_ghost.sh


    # The reward clue - points to river
    cat > .mountain_secret << 'EOF'
⚔️  GHOST BANISHED! 

With the ghost pirate defeated, the ancient spirits whisper of a secret!
They speak of a CODED MESSAGE by the river that holds the key to finding
the golden penguin's final resting place.

📍 CLEAR DIRECTION: Navigate to the river
💡 Command: cd ../../river
🎯 Mission: Decode the cipher using text transformation commands!

Captain Shellbeard's Fourth Clue ✓
EOF

    echo "$(date): Process Pyramid created - Dynamic ghost system ready" >> "$QUEST_LOG"
}

# Challenge 5: Cipher Chambers - FIXED cipher text order!  
create_cipher_chambers() {
    echo -e "${YELLOW}🔐 Constructing the Cipher Chambers...${NC}"
    
    cd ../../river
    
    # Create the cipher with CORRECT text (fixes order issue!)
    echo "YOU:MUST:FIND:THE:GOLDEN:PENGUIN" > cipher.txt
    
    # But present it reversed to make it a puzzle
    echo "PENGUIN:GOLDEN:THE:FIND:MUST:YOU" > cipher.txt
    
    # Detailed cipher instructions
    cat > cipher_guide.txt << 'EOF'
🌊 WELCOME TO THE MYSTICAL RIVER! 🌊

You've discovered an ancient cipher left by Captain Shellbeard himself!
The message is encoded - words are in reverse order, separated by colons.

🎯 YOUR CHALLENGE:
1. View the cipher: cat cipher.txt
2. Replace colons with spaces: cat cipher.txt | tr ':' ' '
3. Reverse word order: cat cipher.txt | tr ':' ' ' | awk '{for(i=NF;i>=1;i--) printf "%s ", $i; print ""}'
   
Alternative method:
cat cipher.txt | tr ':' '\n' | tac | tr '\n' ' '

When decoded correctly, the message should read:
"YOU MUST FIND THE GOLDEN PENGUIN"

This confirms your ultimate quest!
EOF

    # Clear next destination clue
    cat > .river_wisdom << 'EOF'  
🌊 CIPHER DECODED!

The ancient message confirms your destiny: "YOU MUST FIND THE GOLDEN PENGUIN"

But first, you must prove your worthiness by unlocking the sealed treasure chest!
This chest is protected by ancient permission spells.

📍 CLEAR DIRECTION: Return to the mountain base
💡 Command: cd ../mountain/base
🎯 Mission: Find the locked treasure chest and change its permissions!

Captain Shellbeard's Fifth Clue ✓
EOF

    echo "$(date): Cipher Chambers created - Reversed text puzzle ready" >> "$QUEST_LOG"
}

# Challenge 6: Permission Palace - Clear chmod challenge
create_permission_palace() {
    echo -e "${CYAN}🔗 Building the Permission Palace...${NC}"
    
    cd ../mountain/base
    
    # Create the locked treasure chest with FINAL LOCATION
    cat > treasure_chest.txt << 'EOF'
🎁 TREASURE CHEST UNLOCKED! 🎁

Congratulations! By mastering file permissions, you've proven worthy!

🗝️  THE FINAL SECRET REVEALED:
Captain Shellbeard's Golden Penguin lies hidden in the most sacred place:

📍 EXACT LOCATION: .secret_location/ancient_waterfall
💎 HIDDEN FILE: .golden_penguin

🎯 FINAL QUEST STEPS:
1. Navigate to the base directory: cd ../../..
2. Go to the secret location: cd .secret_location/ancient_waterfall  
3. Look for hidden files: ls -la
4. Claim your prize: cat .golden_penguin

The legendary treasure awaits you at the ancient waterfall!

Captain Shellbeard's Final Direction ✓
EOF

    # Lock it with no permissions (fixes permission challenge)
    chmod 000 treasure_chest.txt
    
    # Clear instructions
    cat > permission_guide.txt << 'EOF'
🏰 THE PERMISSION PALACE 🏰

Before you lies a treasure chest sealed by ancient permission magic!
Only one who masters the chmod command can open it.

🎯 YOUR CHALLENGE:
1. Check current permissions: ls -l treasure_chest.txt
   You'll see: ---------- (no permissions at all!)
   
2. Grant read permission: chmod +r treasure_chest.txt
   OR use numeric: chmod 444 treasure_chest.txt
   
3. Verify permissions changed: ls -l treasure_chest.txt
   Should now show: r--r--r--
   
4. Read the treasure: cat treasure_chest.txt

The chest contains the FINAL LOCATION of the Golden Penguin!
EOF

    echo "$(date): Permission Palace created - Locked chest with final clues" >> "$QUEST_LOG"
}

# Final Vault - The Ultimate Treasure
create_final_vault() {
    echo -e "${GOLD}💎 Hiding the Final Vault...${NC}"
    
    cd "$BASE_DIR"
    mkdir -p .secret_location/ancient_waterfall
    cd .secret_location/ancient_waterfall
    
    # Create the legendary Golden Penguin with personalized certificate
    cat > .golden_penguin << EOF
🐧✨💰🏆💎✨🐧

   ╔════════════════════════════════════════╗
   ║                                        ║
   ║         🎊 ULTIMATE VICTORY! 🎊         ║
   ║                                        ║  
   ║     You found Captain Shellbeard's     ║
   ║          GOLDEN PENGUIN!               ║
   ║                                        ║
   ╚════════════════════════════════════════╝

                    🐧
                   /👑 \\
                  /     \\
                 |  ___   |
                  \\  \\_/  /
                   \\_____/
                  💰💰💰💰
                  
🏆 CERTIFICATE OF LINUX MASTERY 🏆
═══════════════════════════════════════════

This certifies that $(whoami) has successfully completed
CAPTAIN SHELLBEARD'S TREASURE HUNT and achieved the rank of:

🌟 LINUX COMMAND LINE LEGEND 🌟

Skills Mastered:
✅ Navigation: pwd, ls, cd, ls -la  
✅ File Operations: cat, cp, mv, wc
✅ Pattern Searching: grep, grep -c, grep -E
✅ Process Control: ps, kill, jobs
✅ Text Processing: tr, pipes |, awk
✅ File Permissions: chmod, ls -l
✅ Problem Solving: Combining commands creatively

Quest Completed: $(date)
Quest ID: $SESSION_ID
Duration: [Check quest.log for full journey]

🎓 You are now ready for advanced topics:
- Docker container management
- Kubernetes debugging  
- Server administration
- DevOps automation
- Cybersecurity analysis

Share this achievement with your instructor!

                🏴‍☠️ Captain Shellbeard 🏴‍☠️
                "The terminals remember what files forget"
EOF

    # Victory celebration message
    cat > victory.txt << 'EOF'
🎉 LEGENDARY ACHIEVEMENT UNLOCKED! 🎉

You have completed the most challenging Linux treasure hunt ever created!

🗺️  YOUR EPIC JOURNEY:
🏛️  Command Temple - Mastered navigation basics
📁 Directory Maze - Conquered file operations  
🔍 Search Sanctum - Wielded grep like a digital sword
⚙️  Process Pyramid - Controlled system spirits
🔐 Cipher Chambers - Decoded ancient messages
🔗 Permission Palace - Unlocked sealed secrets
💎 Final Vault - Claimed the Golden Penguin!

The command line is now your trusted ally in any digital adventure!

🚀 NEXT ADVENTURES AWAIT:
With these foundation skills, you're ready to explore:
- Advanced shell scripting
- Docker and containerization
- Cloud computing platforms  
- Cybersecurity tools
- DevOps automation

The digital realm is yours to command! 🌟
EOF

    echo "$(date): Final Vault created - Golden Penguin hidden at ancient waterfall" >> "$QUEST_LOG"
}

# Create help and progress tracking systems  
create_support_systems() {
    echo -e "${BLUE}📚 Setting up help and progress systems...${NC}"
    
    cd "$BASE_DIR"
    
    # Comprehensive help system
    cat > HELP.txt << 'EOF'
🆘 TREASURE HUNT COMMAND REFERENCE 🆘
═══════════════════════════════════════════

📍 NAVIGATION BASICS
pwd          - Shows your current location path
ls           - Lists files and folders here  
ls -la       - Shows ALL files (including hidden ones starting with .)
cd folder    - Change to a folder
cd ..        - Go back one level up
cd ~         - Go to your home directory

📖 FILE READING  
cat filename     - Display contents of a file
cat .hidden_file - Read hidden files (start with dot)
head filename    - Show first 10 lines
tail filename    - Show last 10 lines

🔍 SEARCHING & FINDING
grep "word" file         - Find lines containing "word"  
grep -c "word" file      - Count how many times "word" appears
grep -i "word" file      - Case-insensitive search
grep -E "word1|word2"    - Search for multiple patterns
find . -name "*.txt"     - Find all .txt files
wc -l filename           - Count lines in a file

⚙️  PROCESS MANAGEMENT
ps aux               - Show all running processes
ps aux | grep name   - Find specific processes  
kill PID             - Stop a process (replace PID with number)
jobs                 - Show background processes
./script.sh          - Run a script

🔧 FILE OPERATIONS
cp source destination    - Copy files
mv oldname newname      - Move/rename files
touch filename          - Create empty file
mkdir foldername        - Create directory
chmod +r filename       - Make file readable
chmod +x filename       - Make file executable  
chmod 755 filename      - Set specific permissions (rwxr-xr-x)

🔗 ADVANCED TECHNIQUES  
command1 | command2     - Send output of command1 to command2
cat file | tr ':' ' '   - Replace colons with spaces
cat file | tr ':' '\n'  - Replace colons with newlines
tac filename            - Display file in reverse order

💡 QUEST-SPECIFIC TIPS
- Every location has clear clues pointing to the next challenge
- Hidden files start with a dot (.) - use 'ls -la' to see them
- Each clue gives you the EXACT next location to visit
- If stuck, read all .txt files in your current location
- Look for files that start with dots for secret clues!

🎯 PROGRESS TRACKING
./check_progress.sh     - See how far you've come
cat quest.log          - View your full adventure log

Remember: Each challenge teaches you valuable real-world Linux skills!
EOF

    # Progress checking script
    cat > check_progress.sh << 'EOF'
#!/bin/bash
echo "🏴‍☠️ CAPTAIN SHELLBEARD'S QUEST PROGRESS 🏴‍☠️"
echo "═══════════════════════════════════════════════════"

# Check each major milestone
checkpoints=(
    "island/beach/.hidden_scroll:🏛️  Command Temple"
    "island/jungle/.jungle_secret:📁 Directory Maze" 
    "island/cave/.cave_secret:🔍 Search Sanctum"
    "island/mountain/base/.mountain_secret:⚙️  Process Pyramid"
    "island/river/.river_wisdom:🔐 Cipher Chambers"
    ".secret_location/ancient_waterfall/.golden_penguin:💎 Final Vault"
)

completed=0
total=6

for checkpoint in "${checkpoints[@]}"; do
    IFS=':' read -r file name <<< "$checkpoint"
    if [ -f "$file" ]; then
        echo "✅ $name - COMPLETED"
        ((completed++))
    else
        echo "⏳ $name - Not yet discovered"
    fi
done

echo ""
echo "📊 Progress: $completed/$total challenges completed"

if [ $completed -eq $total ]; then
    echo "🎉 LEGENDARY STATUS ACHIEVED! You found the Golden Penguin!"
elif [ $completed -ge 4 ]; then
    echo "🌟 You're close to victory! Keep going!"
elif [ $completed -ge 2 ]; then  
    echo "⚔️  You're making great progress, adventurer!"
else
    echo "🚀 Your quest has begun! Follow the clues carefully."
fi

echo ""
echo "💡 Need help? Type: cat HELP.txt"
echo "📜 View full log: cat quest.log"
EOF
    chmod +x check_progress.sh

    # Quick command reference card
    cat > QUICK_REFERENCE.txt << 'EOF'
🎯 ESSENTIAL COMMANDS FOR THIS QUEST 🎯
═══════════════════════════════════════════

NAVIGATION:     pwd | ls | ls -la | cd folder | cd ..
FILE READING:   cat filename | cat .hidden_file  
SEARCHING:      grep "word" file | grep -c "word" file
PROCESSES:      ps aux | kill PID | ./script.sh
FILE OPS:       cp | mv | chmod +r | chmod 755
ADVANCED:       command1 | command2 | tr ':' ' '

🏴‍☠️ Current Quest Status: Type ./check_progress.sh
🆘 Need Help?: Type cat HELP.txt
EOF

    echo "$(date): Support systems created - Help and progress tracking ready" >> "$QUEST_LOG"
}

# Security cleanup - Remove traces of the setup process
security_cleanup() {
    echo -e "${RED}🔐 Activating security measures...${NC}"
    
    # Remove the deployment script itself so students can't see source
    SCRIPT_PATH="$0"
    if [ -f "$SCRIPT_PATH" ] && [[ "$SCRIPT_PATH" != *"bash"* ]]; then
        rm -f "$SCRIPT_PATH" 2>/dev/null
        echo "🗑️  Deployment script self-destructed for security"
    fi
    
    # Create security notice
    cat > "$BASE_DIR/SECURITY_NOTICE.txt" << 'EOF'
🔒 SECURITY NOTICE 🔒

This treasure hunt environment has been secured:
- Source deployment code has been removed
- Quest structure is now locked and ready
- Progress is tracked in quest.log
- No cheat files or shortcuts available

Play fair and enjoy the learning experience! 
The real treasure is the Linux skills you gain along the way.

🏴‍☠️ Captain Shellbeard
EOF

    # Final log entry
    echo "$(date): Security cleanup completed - Quest environment secured" >> "$QUEST_LOG"
    echo "$(date): All challenges ready - Adventure may begin!" >> "$QUEST_LOG"
}

# Main deployment sequence
main() {
    print_welcome_banner
    initialize_quest
    
    echo -e "\n${PURPLE}🏗️  Constructing the Seven Sacred Realms...${NC}"
    create_command_temple
    create_directory_maze  
    create_search_sanctum
    create_process_pyramid
    create_cipher_chambers
    create_permission_palace
    create_final_vault
    
    create_support_systems
    security_cleanup
    
    # Final instructions
    clear
    echo -e "${GREEN}${BOLD}"
    cat << "EOF"
🎉 QUEST ENVIRONMENT READY! 🎉
═══════════════════════════════════════

Your adventure begins NOW!
EOF
    echo -e "${NC}"
    
    echo -e "${CYAN}📁 Quest Location: ${BOLD}$BASE_DIR${NC}"
    echo -e "${YELLOW}🚀 Start Command: ${BOLD}cd $BASE_DIR && ls${NC}"
    echo -e "${PURPLE}📖 First Stop: ${BOLD}cd island/beach${NC}"
    echo -e "${BLUE}❓ Need Help: ${BOLD}cat HELP.txt${NC}"
    echo -e "${GREEN}📊 Check Progress: ${BOLD}./check_progress.sh${NC}"
    
    echo ""
    echo -e "${RED}${BOLD}⚠️  IMPORTANT REMINDERS:${NC}"
    echo "• Every clue clearly leads to the next location"
    echo "• Hidden files start with a dot (use ls -la)"
    echo "• Follow the story - each challenge builds on the previous"
    echo "• Real-time help available in HELP.txt"
    echo "• Have fun and learn valuable Linux skills!"
    
    echo ""
    echo -e "${CYAN}May the command line be with you, brave adventurer!${NC}"
    echo -e "${YELLOW}🏴‍☠️ Captain Shellbeard${NC}"
    
    # Auto-navigate to start location
    cd "$BASE_DIR"
}

# Execute the main deployment
main
