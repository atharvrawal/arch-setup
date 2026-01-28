//Modify this file to change what commands output to your statusbar, and recompile using the make command.

static const Block blocks[] = {
    /* Icon */   /* Command */                                                /* Interval */ /* Signal */
    {"  ",       "grep 'cpu ' /proc/stat | awk '{printf \"%d%%\", ($2+$4)*100/($2+$4+$5)}'",   5,  0},
    {"  ",       "free -h | awk '/^Mem/ {print $3\"/\"$2}' | sed s/i//g",       10, 0},
    {" ",       "df -h / | awk 'NR==2 {print $3\"/\"$2}'",                    60, 0},
    {"  ",       "pamixer --get-volume-human",                               2,  0},
    {"󰥔 ",      "date '+%b %d (%a) %H:%M %p'",                                   5,  0},
};


//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = " | ";
static unsigned int delimLen = 5;
