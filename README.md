# terragrunt-examples
Terraform and Terragrunt examples.

Sometimes I find it too difficult to find terraform examples of AWS things. This is organized into a series of microservice modules, and uses terragrunt to apply them. I choose to utilize a env.key or env_vars.sh file to
set the environment variables and take a look at example.key for an example.

If you've never used terragrunt before, I highly recommend it instead of a "bare" terraform deployment. Bonus points for adding an `alias tg=terragrunt` to your .bashrc

## List of Examples
- [Full Terragrunt Project](terragrunt_full_example/): An example mono-repo style with dev and prod deployments, and keeping things as DRY as possible while still making sense.
- [An example static website with Cloudfront](modules/cloudfront_static_website): A simple, but complete static
website hosted via cloudfront and s3. This also automatically syncs a local folder with the remote s3 bucket so
all you have to do is `terragrunt apply`
- [VPS with full internet access](modules/public_ec2): A simple EC2 instance with all the networking configured
so you can SSH into it and it can access the internet.

## Why?

The point of this is to provide "copy&paste" templates to start a new project on. Obviously, these don't cover everything but they cover some of the more tedious bits of starting new projects (like creating a new VPC that is publicly routable - a lot of steps, but not complicated and easy to change to fit your needs)

MIT licensed, so do whatever you want with it and be nice.
