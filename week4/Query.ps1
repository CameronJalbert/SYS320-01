. "C:\Users\champuser\SYS320-01\week4\Classtable.ps1"

$FullTable = gatherClasses

# list all classes of instructor Paligu
# $FullTable | select "Class Code", Instructor, Location, Days, "Time Start", "Time End" |
# where { $_."Instructor" -ilike "Furkan Paligu" }

# List all the classes of a room on mondays, Display only times, and code. Sort by start time
# $FullTable | Where-Object { ($_.Location -ilike "JOYC 310") -and ($_.Days -ilike "Monday") } |
#             Sort-Object "Time Start" |
#             Select-Object "Time Start", "Time End", "Class Code"

# Make a list of all the instructors that teach at least 1 course in one of the courses: 
# SYS, NET, SEC, FOR, CSI, DAT. Sort by name and make it unique 
$ITSInstructors = $FullTable |
    Where-Object {
        ($_.“Class Code” -like "SYS*") -or
        ($_.“Class Code” -like "NET*") -or
        ($_.“Class Code” -like "SEC*") -or
        ($_.“Class Code” -like "FOR*") -or
        ($_.“Class Code” -like "CSI*") -or
        ($_.“Class Code” -like "DAT*")
    } #Select-Object Instructor | Sort-Object Instructor -Unique

#$ITSInstructors

# Number of classes taught by prof descending
$FullTable | where { $_.Instructor -in $ITSInstructors.Instructor } |
             Group-Object "Instructor" |
             Select-Object Count, Name |
             Sort-Object Count -Descending