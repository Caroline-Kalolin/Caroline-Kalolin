<#
The following configuration variables are supported in the config file:
aws_access_key_id - The AWS access key part of your credentials
aws_secret_access_key - The AWS secret access key part of your credentials
aws_session_token - The session token part of your credentials (session tokens only)
metadata_service_timeout - The number of seconds to wait until the metadata service request times out. This is used if you are using an IAM role to provide your credentials.
metadata_service_num_attempts - The number of attempts to try to retrieve credentials. If you know for certain you will be using an IAM role on an Amazon EC2 instance, you can set this value to ensure any intermittent failures are retried. By default this value is 1.
#>
# Reference: https://docs.aws.amazon.com/cli/latest/reference/configure/

<#
To create a new configuration:
$ aws configure
AWS Access Key ID [None]: accesskey
AWS Secret Access Key [None]: secretkey
Default region name [None]: us-west-2
Default output format [None]:
#>

aws configure