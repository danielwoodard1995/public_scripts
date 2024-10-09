# Define the list of usernames
$usernames = 'UserA', 'UserB', 'UserC'

# Loop through each username and remove their profiles in parallel
foreach ($username in $usernames) {
    Start-Job -ScriptBlock {
        param ($username)
        
        Write-Output "Starting removal process for user profile: $username"
        
        $profiles = Get-CimInstance -Class Win32_UserProfile | Where-Object { $_.LocalPath.split('\')[-1] -eq $username }
        
        foreach ($profile in $profiles) {
            Write-Output "Removing profile for user: $username"
            Remove-CimInstance -InputObject $profile
        }
        
        Write-Output "Completed removal process for user profile: $username"
    } -ArgumentList $username
}

# Wait for all jobs to complete
Get-Job | Wait-Job

# Retrieve and display job outputs
Get-Job | ForEach-Object {
    $job = $_
    $jobOutput = Receive-Job -Job $job
    Write-Output $jobOutput
}

# Clean up completed jobs
Get-Job | Remove-Job
