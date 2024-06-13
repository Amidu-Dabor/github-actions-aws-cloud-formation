$StackName = 'newstack'
$TemplateBody = Get-Content -Path cloudformation-vpc.yml -Raw

# New-CFNStack -StackName $StackName -TemplateBody $TemplateBody


param (
    [string]$StackName,
    [string]$TemplateBody
)

function New-OrUpdate-CFNStack {
    param (
        [string]$StackName,
        [string]$TemplateBody
    )

    $stackExists = (Get-CFNStack -StackName $StackName -ErrorAction SilentlyContinue) -ne $null

    if ($stackExists) {
        Write-Host "Stack [$StackName] already exists. Updating the stack..."
        Update-CFNStack -StackName $StackName -TemplateBody $TemplateBody
        if ($?) {
            Write-Host "Stack [$StackName] updated successfully."
        } else {
            Write-Host "Failed to update stack [$StackName]."
            exit 1
        }
    } else {
        Write-Host "Creating new stack [$StackName]..."
        New-CFNStack -StackName $StackName -TemplateBody $TemplateBody
        if ($?) {
            Write-Host "Stack [$StackName] created successfully."
        } else {
            Write-Host "Failed to create stack [$StackName]."
            exit 1
        }
    }
}

# Execute the function with provided parameters
New-OrUpdate-CFNStack -StackName $StackName -TemplateBody $TemplateBody

