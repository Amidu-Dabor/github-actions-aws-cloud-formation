param (
    [string]$StackName = 'aws-vpc-stack',
    [string]$TemplateBody = Get-Content -Path 'cloudformation-vpc.yml' -Raw
)

function New-OrUpdate-CFNStack {
    param (
        [string]$StackName,
        [string]$TemplateBody
    )

    $stackExists = Get-CFNStack -StackName $StackName -ErrorAction SilentlyContinue -ne $null

    if ($stackExists) {
        Write-Host "Stack [$StackName] already exists. Updating the stack..."
        try {
            Update-CFNStack -StackName $StackName -TemplateBody $TemplateBody -ErrorAction Stop
            Write-Host "Stack [$StackName] updated successfully."
        } catch {
            if ($_.Exception.Message -like "*No updates are to be performed*") {
                Write-Host "No updates are to be performed on stack [$StackName]."
            } else {
                Write-Host "Failed to update stack [$StackName]: $_"
                exit 1
            }
        }
    } else {
        Write-Host "Creating new stack [$StackName]..."
        try {
            New-CFNStack -StackName $StackName -TemplateBody $TemplateBody -ErrorAction Stop
            Write-Host "Stack [$StackName] created successfully."
        } catch {
            Write-Host "Failed to create stack [$StackName]: $_"
            exit 1
        }
    }
}

# Execute the function with provided parameters
New-OrUpdate-CFNStack -StackName $StackName -TemplateBody $TemplateBody
