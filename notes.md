# Terraform Cloud

To save terraform state in the cloud :

- Create an account in the Terraform Cloud

https://app.terraform.io/app/

- Create an organization. It will be used in the terraform config plan. 
- Create an independent workspace for each state to save. It will be used in the terraform config plan.
- Select Terraform CLI integration with Terraform Cloud.
- Create a project other than default, or select an existing project (not sure at this point what it's used for). It will not be used in the terraform config plan. 
- Select execution mode "Local" (not "Remote") in the workspace settings. That will save only the state in Terraform Cloud, not the plan/scripts. Important to avoid an error with terraform CLI. 
- Add following config in main.tf
Terraform Cloud

To save terraform state in the cloud :

Create an account in the Terraform Cloud

https://app.terraform.io/app/

Create an organization. It will be used in the terraform config plan. 
Create an independent workspace for each state to save. It will be used in the terraform config plan.
Select Terraform CLI integration with Terraform Cloud.
Create a project other than default, or select an existing project (not sure at this point what it's used for). It will not be used in the terraform config plan. 
Select execution mode "Local" (not "Remote") in the workspace settings. That will save only the state in Terraform Cloud, not the plan/scripts. Important to avoid an error with terraform CLI. 
Add following config in main.tf

# Known Issues
## Error: Invalid function argument

If you have the error `Error: Invalid function argument` and `Invalid value for "path" parameter: no file exists at`, it's because you have selected the "Remote" execution mode instead of "Local" in the workspace settings ot Terraform Cloud. That will save only the state in Terraform Cloud, not the plan/scripts. Important to avoid that error with terraform CLI. 

```bash
vincelf@DESKTOP-5N9VHFK:~/vscode-workspaces/terraform-projects/magic_castle-openstack-release$ tf destroy
Running apply in Terraform Cloud. Output will stream here. Pressing Ctrl-C
will cancel the remote apply if it's still pending. If the apply started it
will stop streaming the logs, but will not stop the apply running remotely.

Preparing the remote apply...

To view this run in a browser, visit:
https://app.terraform.io/app/def-elalib-ivado-tfcloud-org/alliancecan-ivado-magic_castle-ca-east/runs/run-Casnm1ZvrDej1N2p

Waiting for the plan to start...

Terraform v1.4.2
on linux_amd64
Initializing plugins and modules...
╷
│ Error: Invalid function argument
│ 
│   on main.tf line 51, in module "openstack":
│   51:   public_keys = [file("~/.ssh/id_rsa_hp655g9_wsl_arbutus.pub")]
│     ├────────────────
│     │ while calling file(path)
│ 
│ Invalid value for "path" parameter: no file exists at
│ "~/.ssh/id_rsa_hp655g9_wsl_arbutus.pub"; this function works only with
│ files that are distributed as part of the configuration source code, so if
│ this file will be created by a resource in this configuration you must
│ instead obtain this result from an attribute of that resource.
╵
Operation failed: failed running terraform plan (exit 1)
```