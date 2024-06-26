#
# Example script to Bulk Select repository Use Case
#

[CmdletBinding()]
param (
    [Parameter()]
    [string]$ApiVersion = "1.0",

    [Parameter(Mandatory=$true)]
    [string]$AccessToken,

    [Parameter()]
    [int]$UseCaseId = 0

)
begin {
    # Debricked JWT Token
    $DebrickedToken = ""

    # Default headers
    $Headers = @{
        'Accept' = "*/*"
        'Content-Type' = "application/json"
    }
}
process {

    # Parse Response Object
    $Response = $null

    # Authenticate to retrieve Debricked JWT Token
    Write-Host "Retrieving Debricked JWT token ..."
    $Body = @{
        refresh_token = $AccessToken
    }
    $Params = @{
        Uri = "https://debricked.com/api/login_refresh"
        ErrorAction = 'Stop'
        Method = 'POST'
        Body = (ConvertTo-Json $Body)
    }
    try  {
        $Response = Invoke-RestMethod -Headers $Headers @Params
        Write-Verbose $Response
        $DebrickedToken = $Response.token
        $Headers.Add('Authorization', "Bearer $DebrickedToken")
    } catch {
        Write-Error -Exception $_.Exception -Message "Debricked API call failed: $_"
    }
    #Write-Host $DebrickedToken

    Write-Host "Retrieving Repositories..."
    $Params = @{
        Uri = "https://debricked.com/api/$ApiVersion/open/repositories/get-repositories-names-links"
        ErrorAction = 'Stop'
        Method = 'GET'
    }
    try  {
        $Repositories = Invoke-RestMethod -Headers $Headers @Params
    } catch {
        Write-Error -Exception $_.Exception -Message "Debricked API call failed: $_"
    }
    #$Repositories
    foreach ($r in $Repositories) {
        $RepoId = $r.id
        $RepoName = $r.name
        Write-Host "Setting repository id: $RepoId, name: $RepoName to use case: $UseCaseId"
        $Body = @{
            useCase = $UseCaseId
        }
        $Params = @{
            Uri = "https://debricked.com/api/$ApiVersion/open/repository-settings/repositories/$RepoId/select-use-case"
            ErrorAction = 'Stop'
            Method = 'POST'
            Body = (ConvertTo-Json $Body)
        }
        #Write-Host "Headers:"
        #foreach ($h in $Headers.GetEnumerator()) { Write-Host "$($h.Name) : $($h.Value)" }
        #Write-Host "Params:"
        #foreach ($h in $Params.GetEnumerator()) { Write-Host "$($h.Name) : $($h.Value)" }
        try  {
            $Response = Invoke-RestMethod -Headers $Headers @Params
            Write-Host $Response
        } catch {
            Write-Error -Exception $_.Exception -Message "Debricked API call failed: $_"
        }
        Write-Host "Waiting for 5 seconds ..."
        Start-Sleep -Seconds 5

    }

}
end {

}