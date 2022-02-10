# ACME_vcs_example

#About
This is an exmaple configuration to deploy to AWS, GCP, and StackPath using Terraform Cloud with code residing in Github.

#Configuration
Set up a Variable Set in Terraform Cloud with the below environment varibles:

GCP
Create an environment variable called GOOGLE_CREDENTIALS in your Terraform Cloud workspace.
Remove the newline characters from your JSON key file and then paste the credentials into the environment variable value field.
Mark the variable as Sensitive and click Save variable.
All runs within the workspace will use the GOOGLE_CREDENTIALS variable to authenticate with Google Cloud Platform.

AWS
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY

StackPath
TF_VAR_stackpath_stack_id
TF_VAR_stackpath_client_id
TF_VAR_stackpath_client_secret

Please note that the prefix TF_VAR_ may be necessary to upgrade the priority of these variables.
