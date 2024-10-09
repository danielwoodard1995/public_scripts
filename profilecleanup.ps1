$usersPath = 'C:\Users'

$profileWhiteList = @("Public", "Default", "Administrator", "Guest", "WDAGUtilityAccount", "ictsupport")

$folders = Get-ChildItem -Path $usersPath -Directory

foreach ($folder in $folders) {
    if ($profileWhiteList -notcontains $folder.Name) {
        try {
            Remove-Item -Path $folder.FullName -Recurse -Force
            Write-Output "Deleted folder: $($folder.FullName)"
        } catch {
                Write-Output "Failed to delete folder named: $($folder.FullName). Error: $_"
                
            } else {
                Write-Output "Skipping folder: $($folder.FullName)"
        }
    }
}

# Initialize the whiteList
$whiteList = @("ictsupport", "Default", "Administrator")

# Retrieve user profiles
$userProfiles = Get-WmiObject -Class Win32_UserProfile

# Extract SIDs for the whiteList
$whiteListSIDs = @()
foreach ($profile in $userProfiles) {
    $userName = $profile.LocalPath.Split('\')[-1]
    if ($whiteList -contains $userName) {
        $whiteListSIDs += $profile.SID
    }
}

# Compare all SIDs and delete profiles that are not in the whiteList
foreach ($profile in $userProfiles) {
    $userName = $profile.LocalPath.Split('\')[-1]
    if ($whiteListSIDs -contains $profile.SID) {
        Write-Output "Profile $($userName), was not deleted"
    } else {
        # Delete the profile
        $profile.Delete()
        Write-Output "Deleted profile: $userName"
    }
}