#
# Example script to List Available Repository Use Cases
#

[CmdletBinding()]
param (
    [Parameter()]
    [string]$ApiVersion = "1.0",

    [Parameter()]
    [string]$AccessToken,

    [Parameter()]
    [int]$UseCaseId = 0

)
begin {
    # Debricked JWT Token
    $DebrickedToken = ""

    # Default headers
    $Headers = @{
        'Accept' = "application/json"
        'Content-Type' = "application/json"
    }

    # Use Case Values
    $UseCaseValues =@{}
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

    # Get possible Use Case values
    Write-Host "Retrieving Repository Use Case values ..."
    $Params = @{
        Uri = "https://debricked.com/api/$ApiVersion/open/repository-settings/available-use-cases"
        ErrorAction = 'Stop'
        Method = 'GET'
    }
    try  {
        $UseCaseValues = Invoke-RestMethod -Headers $Headers @Params
    } catch {
        Write-Error -Exception $_.Exception -Message "Debricked API call failed: $_"
    }
}
end {
    $UseCaseValues
}