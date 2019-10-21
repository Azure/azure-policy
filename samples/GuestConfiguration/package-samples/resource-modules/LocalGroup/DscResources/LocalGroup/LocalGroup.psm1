function Get-LocalGroupMembers
{
    [CmdletBinding()]
    [OutputType([String[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $GroupName
    )

    $localGroupMembers = net localgroup $GroupName

    if ($null -ne $localGroupMembers -and $localGroupMembers.Count -gt 0)
    {
        <#
            Here is an example of the output from the net localgroup command: 
            Alias name     Administrators
            Comment

            Members

            -------------------------------------------------------------------------------
            Administrator
            Member 3
            Member 24
            Member 52
            The command completed successfully.

        #>
        $firstMemberIndex = 6
        $lastMemberIndex = $localGroupMembers.Count - 3

        if ($lastMemberIndex -ge $firstMemberIndex)
        {
            $localGroupMembers = $localGroupMembers[$firstMemberIndex..$lastMemberIndex]
        }
        else
        {
            $localGroupMembers = $null
        }
    }

    return $localGroupMembers
}

function Get-ReasonsLocalGroupMembersDoNotMatchExpected
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $GroupName,

        [Parameter(ParameterSetName = "Members")]
        [String[]]
        $Members,

        [Parameter(ParameterSetName = "MembersToIncludeOrExclude")]
        [String[]]
        $MembersToInclude,

        [Parameter(ParameterSetName = "MembersToIncludeOrExclude")]
        [String[]]
        $MembersToExclude
    )

    $reasons = @()
    $reasonCodePrefix = 'LocalGroup:LocalGroup'

    $actualMembersList = @(Get-LocalGroupMembers -GroupName $GroupName)

    if ($PSCmdlet.ParameterSetName -eq 'Members' -and $null -ne $Members)
    {
        Write-Verbose -Message "Processing Members parameter..."
        if ($Members.Count -gt 0)
        {
            Write-Verbose -Message "Comparing $($Members.Count) members..."
            if ($null -eq $actualMembersList -or $actualMembersList.Count -eq 0)
            {
                Write-Verbose -Message 'Group is empty when members were expected.'
                $reason = @{
                    Code = $reasonCodePrefix + ':GroupEmptyWhenMembersExpected'
                    Phrase = "Could not find any members in the local group with the name '$GroupName' when members were expected."
                }
                $reasons += $reason
            }
            else
            {
                $memberComparisonResult = Compare-Object -ReferenceObject $Members -DifferenceObject $actualMembersList -IncludeEqual

                foreach ($memberComparison in $memberComparisonResult)
                {
                    Write-Verbose -Message "Member comparison result for member '$($memberComparison.InputObject)' is '$($memberComparison.SideIndicator)'."
                    
                    if ($memberComparison.SideIndicator -eq '<=')
                    {
                        Write-Verbose -Message 'Could not find expected member.'
                        $reason = @{
                            Code = $reasonCodePrefix + ':ExpectedMemberMissing'
                            Phrase = "Could not find a member with the name '$($memberComparison.InputObject)' in the local group with the name '$GroupName'."
                        }
                        $reasons += $reason
                    }
                    elseif ($memberComparison.SideIndicator -eq '=>')
                    {
                        Write-Verbose -Message 'Found unexpected member.'
                        $reason = @{
                            Code = $reasonCodePrefix + ':UnexpectedMemberFound'
                            Phrase = "Found an unexpected member with the name '$($memberComparison.InputObject)' in the local group with the name '$GroupName'."
                        }
                        $reasons += $reason
                    }
                }
            }
        }
        else
        {
            if ($null -ne $actualMembersList -and $actualMembersList.Count -gt 0)
            {
                Write-Verbose -Message 'Group is not empty when no members were expected.'
                $reason = @{
                    Code = $reasonCodePrefix + ':GroupNotEmptyWhenNoMembersExpected'
                    Phrase = "Found members in the local group with the name '$GroupName' when no members were expected."
                }
                $reasons += $reason
            }
        }   
    }

    if ($PSCmdlet.ParameterSetName -eq 'MembersToIncludeOrExclude')
    {
        if ($null -ne $MembersToInclude -and $MembersToInclude.Count -gt 0)
        {
            Write-Verbose -Message "Comparing $($MembersToInclude.Count) members to include..."
            if ($null -eq $actualMembersList -or $actualMembersList.Count -eq 0)
            {
                Write-Verbose -Message 'Group is empty when members were expected.'
                $reason = @{
                    Code = $reasonCodePrefix + ':GroupEmptyWhenMembersExpected'
                    Phrase = "Could not find any members in the local group with the name '$GroupName' when members were expected."
                }
                $reasons += $reason
            }
            else
            {
                $memberComparisonResult = Compare-Object -ReferenceObject $MembersToInclude -DifferenceObject $actualMembersList -IncludeEqual

                foreach ($memberComparison in $memberComparisonResult)
                {
                    Write-Verbose -Message "Member comparison result for member '$($memberComparison.InputObject)' is '$($memberComparison.SideIndicator)'."
                    
                    if ($memberComparison.SideIndicator -eq '<=')
                    {
                        Write-Verbose -Message 'Could not find expected member.'
                        $reason = @{
                            Code = $reasonCodePrefix + ':IncludedMemberMissing'
                            Phrase = "Could not find a member with the name '$($memberComparison.InputObject)' in the local group with the name '$GroupName'."
                        }
                        $reasons += $reason
                    }
                }
            }
        }

        if ($null -ne $MembersToExclude -and $MembersToExclude.Count -gt 0)
        {
            Write-Verbose -Message "Comparing $($MembersToExclude.Count) members to exclude..."
            if ($null -eq $actualMembersList -or $actualMembersList.Count -eq 0)
            {
                Write-Verbose -Message 'Group is empty but members were not expected.'
            }
            else
            {
                $memberComparisonResult = Compare-Object -ReferenceObject $MembersToExclude -DifferenceObject $actualMembersList -IncludeEqual

                foreach ($memberComparison in $memberComparisonResult)
                {
                    Write-Verbose -Message "Member comparison result for member '$($memberComparison.InputObject)' is '$($memberComparison.SideIndicator)'."
                    
                    if ($memberComparison.SideIndicator -eq '==')
                    {
                        Write-Verbose -Message 'Found member that should be excluded.'
                        $reason = @{
                            Code = $reasonCodePrefix + ':ExcludedMemberFound'
                            Phrase = "Found a member that should be excluded with the name '$($memberComparison.InputObject)' in the local group with the name '$GroupName'."
                        }
                        $reasons += $reason
                    }
                }
            }
        }
    }

    return $reasons
}

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $GroupName,

        [Parameter()]
        [String]
        $Members,

        [Parameter()]
        [String]
        $MembersToInclude,

        [Parameter()]
        [String]
        $MembersToExclude
    )

    $actualMembersList = @(Get-LocalGroupMembers -GroupName $GroupName)
    $actualMembersListAsString = $actualMembersList -join '; '

    $localGroupInfo = @{
        GroupName = $GroupName
        Members = $actualMembersListAsString
    }

    $getReasonsLocalGroupMembersDoNotMatchExpectedParameters = @{
        GroupName = $GroupName
    }

    if ($PSBoundParameters.ContainsKey('Members') -and $null -ne $Members)
    {
        if ([String]::IsNullOrEmpty($Members))
        {
            $getReasonsLocalGroupMembersDoNotMatchExpectedParameters['Members'] = @()
        }
        else
        {
            $getReasonsLocalGroupMembersDoNotMatchExpectedParameters['Members'] = $Members.Split(';').Trim()
        }
    }

    if ($PSBoundParameters.ContainsKey('MembersToInclude') -and $null -ne $MembersToInclude)
    {
        if ([String]::IsNullOrEmpty($MembersToInclude))
        {
            $getReasonsLocalGroupMembersDoNotMatchExpectedParameters['MembersToInclude'] = @()
        }
        else
        {
            $getReasonsLocalGroupMembersDoNotMatchExpectedParameters['MembersToInclude'] = $MembersToInclude.Split(';').Trim()
        }
    }
    
    if ($PSBoundParameters.ContainsKey('MembersToExclude') -and $null -ne $MembersToExclude)
    {
        if ([String]::IsNullOrEmpty($MembersToExclude))
        {
            $getReasonsLocalGroupMembersDoNotMatchExpectedParameters['MembersToExclude'] = @()
        }
        else
        {
            $getReasonsLocalGroupMembersDoNotMatchExpectedParameters['MembersToExclude'] = $MembersToExclude.Split(';').Trim()
        }
    }

    $reasons = @(Get-ReasonsLocalGroupMembersDoNotMatchExpected @getReasonsLocalGroupMembersDoNotMatchExpectedParameters)

    if ($null -ne $reasons -and $reasons.Count -gt 0)
    {
        $localGroupInfo['Reasons'] = $reasons
    }

    return $localGroupInfo
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $GroupName,

        [Parameter()]
        [String]
        $Members,

        [Parameter()]
        [String]
        $MembersToInclude,

        [Parameter()]
        [String]
        $MembersToExclude
    )

    $getReasonsLocalGroupMembersDoNotMatchExpectedParameters = @{
        GroupName = $GroupName
    }

    if ($PSBoundParameters.ContainsKey('Members') -and $null -ne $Members)
    {
        if ([String]::IsNullOrEmpty($Members))
        {
            $getReasonsLocalGroupMembersDoNotMatchExpectedParameters['Members'] = @()
        }
        else
        {
            $getReasonsLocalGroupMembersDoNotMatchExpectedParameters['Members'] = $Members.Split(';').Trim()
        }
    }

    if ($PSBoundParameters.ContainsKey('MembersToInclude') -and $null -ne $MembersToInclude)
    {
        if ([String]::IsNullOrEmpty($MembersToInclude))
        {
            $getReasonsLocalGroupMembersDoNotMatchExpectedParameters['MembersToInclude'] = @()
        }
        else
        {
            $getReasonsLocalGroupMembersDoNotMatchExpectedParameters['MembersToInclude'] = $MembersToInclude.Split(';').Trim()
        }
    }
    
    if ($PSBoundParameters.ContainsKey('MembersToExclude') -and $null -ne $MembersToExclude)
    {
        if ([String]::IsNullOrEmpty($MembersToExclude))
        {
            $getReasonsLocalGroupMembersDoNotMatchExpectedParameters['MembersToExclude'] = @()
        }
        else
        {
            $getReasonsLocalGroupMembersDoNotMatchExpectedParameters['MembersToExclude'] = $MembersToExclude.Split(';').Trim()
        }
    }

    $reasons = @(Get-ReasonsLocalGroupMembersDoNotMatchExpected @getReasonsLocalGroupMembersDoNotMatchExpectedParameters)

    if ($null -ne $reasons -and $reasons.Count -gt 0)
    {
        return $false
    }

    return $true
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $GroupName,

        [Parameter()]
        [String]
        $Members,

        [Parameter()]
        [String]
        $MembersToInclude,

        [Parameter()]
        [String]
        $MembersToExclude
    )

    throw 'Set functionality is not supported in this version of the DSC resource.'
}
