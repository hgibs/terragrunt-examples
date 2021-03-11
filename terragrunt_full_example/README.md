#Full Example

This is a "production" example of a mono-repo IaC project.

Note that the `live/dev/terragrunt.hcl` is a symbolic link to `live/prod/terragrunt.hcl`. The `env.hcl` is different in each environment.

Each new module is created in prod, then sym-linked in dev. (i.e. running `ln -s ../../prod/core/terragrunt.hcl terragrunt.hcl` in the live/dev/core directory)

## How is this used?
- IaC code edited in the infrastructure set of modules
- Deployed by running `terragrunt apply-all` in live/dev or live/prod (or running `terragrunt apply` in a specific module)
- This is a really good use case for AWS Organizations too!
