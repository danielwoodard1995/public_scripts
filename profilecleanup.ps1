# Define the list of usernames
$usernames = 'UserA', 'UserB', 'UserC'

# Loop through each username and remove their profiles
foreach ($username in $usernames) {
    $profiles = Get-CimInstance -Class Win32_UserProfile | Where-Object { $_.LocalPath.split('\')[-1] -eq $username }
    
    foreach ($profile in $profiles) {
        Remove-CimInstance -InputObject $profile
    }
}
