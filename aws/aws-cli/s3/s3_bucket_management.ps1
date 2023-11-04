<# this script empty and delete s3 buckets
References:
https://docs.aws.amazon.com/cli/latest/reference/s3api/list-buckets.html
https://docs.aws.amazon.com/AmazonS3/latest/userguide/empty-bucket.html
https://docs.aws.amazon.com/AmazonS3/latest/userguide/delete-bucket.html
#>


# Function to get all S3 buckets
Function GetAllS3Buckets {
    $buckets = aws s3api list-buckets --query "Buckets[].Name" | ConvertFrom-Json
    if (!$buckets) {
        Write-Host "No S3 bucket exists in the AWS tenancy." -ForegroundColor Green
    }
    return $buckets
}

# Function to get specfic S3 bucket
Function GetS3Bucket {
    param(
        [string]$bucketName
    )
    $buckets = GetAllS3Buckets
    if ($buckets -notcontains $bucketName){
        Write-Host "S3 Bucket: $bucketName do not exists." -ForegroundColor Green
        return $null
    }
    return $buckets
}

# Function to list all S3 buckets
Function ListAllS3Buckets {
    $buckets = GetAllS3Buckets
    if ($buckets) {
        foreach ($bucketName in $buckets){
            $index = $buckets.IndexOf($bucketName)
            Write-Host "$index) $bucketName"
        }
    }
}

# Function to empty a specfic S3 bucket
Function EmptyS3Bucket {
    param(
        [string]$bucketName
    )
    if (GetS3Bucket -bucketName $bucketName) {
        aws s3 rm s3://$bucketName --recursive
        Write-Host "$bucketName has been emptied." -ForegroundColor Green
    }
}

# Function to empty all S3 buckets
Function EmptyAllS3Bucket {
    $buckets = GetAllS3Buckets
    foreach ($bucketName in $buckets){
        $index = $buckets.IndexOf($bucketName)
        aws s3 rm s3://$bucketName --recursive
        Write-Host "$index) $bucketName has been emptied." -ForegroundColor Green
    }
}

# Function to delete a specific S3 bucket
Function DeleteS3Bucket {
    param(
        [string]$bucketName
    )
    if (GetS3Bucket -bucketName $bucketName) {
        aws s3 rb s3://$bucketName --force
        Write-Host "$bucketName has been deleted." -ForegroundColor Red
    }
}

# Function to delete all S3 buckets
Function DeleteAllS3Buckets {
    $buckets = GetAllS3Buckets
    if ($buckets) {
        foreach ($bucketName in $buckets) {
            $index = $buckets.IndexOf($bucketName)
            aws s3 rb s3://$bucket --force
            Write-Host "$index) $bucketName has been deleted." -ForegroundColor Red
        }
    }
}

# Main menu
while($true) {
    Write-Host ""
    Write-Host "AWS S3 Bucket Management"
    Write-Host "** this script does not delete S3 Bucket with versioning enabled **"
    Write-Host "1) List S3 Buckets"
    Write-Host "2) Empty a Specific S3 Bucket"
    Write-Host "3) Empty All S3 Buckets"
    Write-Host "4) Delete a Specific S3 Bucket"
    Write-Host "5) Delete All S3 Buckets"
    Write-Host "0) Exit"
    $choice = Read-Host "Enter your choice (0/1/2/3/4/5):"
    switch ($choice) {
        '0' {
            Write-Host "Exiting the script." -ForegroundColor White -BackgroundColor Black -NoNewline
            Write-Host ""
            exit
        }
        '1' {
            ListAllS3Buckets
        }
        '2' {
            $bucketName = Read-Host "Enter the name of the S3 bucket to empty:"
            $confirm = Read-Host "Are you sure you want to empty $bucketName? (yes/no)"
            if ($confirm.ToLower() -eq 'yes') {
                EmptyS3Bucket -bucketName $bucketName
            } else {
                Write-Host "Operation canceled."
            }
        }
        '3' {
            $confirm = Read-Host "Are you sure you want to empty all S3 buckets? (yes/no)"
            if ($confirm.ToLower() -eq 'yes') {
                EmptyAllS3Bucket
            } else {
                Write-Host "Operation canceled."
            }
        }
        '4' {
            $bucketName = Read-Host "Enter the name of the S3 bucket to delete:"
            $confirm = Read-Host "Are you sure you want to delete $bucketName? (yes/no)"
            if ($confirm.ToLower() -eq 'yes') {
                DeleteS3Bucket -bucketName $bucketName
            } else {
                Write-Host "Operation canceled."
            }
        }
        '5' {
            $confirm = Read-Host "Are you sure you want to delete all S3 buckets? (yes/no)"
            if ($confirm.ToLower() -eq 'yes') {
                DeleteAllS3Buckets
            } else {
                Write-Host "Operation canceled."
            }
        }
        default {
            Write-Host "Invalid choice. Please select a valid option (0/1/2/3/4/5)." -ForegroundColor Red -BackgroundColor Yellow -NoNewline
        }
    }
}