function Remove-UserProfiles {
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string[]]$usernames
    )

    process {
        foreach ($username in $usernames) {
            $profiles = Get-CimInstance -Class Win32_UserProfile | Where-Object { $_.LocalPath.split('\')[-1] -eq $username }
            
            foreach ($profile in $profiles) {
                Remove-CimInstance -InputObject $profile
            }
        }
    }
}

# Example usage
'UserA', 'UserB', 'UserC' | Remove-UserProfiles
