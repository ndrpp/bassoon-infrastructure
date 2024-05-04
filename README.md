# Infrastructure for Astro portofolio written in Terraform

## What this does

- creates an S3 bucket setup for <b>static website hosting</b> with a bucket policy
allowing public read access + a referer header check to restrict direct access 
on the bucket
- creates the cloudfront distribution to act as CDN cache for the static files
hosted in S3

## Next steps

- add a custom domain name to the distribution with an SSL certificate

## Using this template

Prerequisites:
- terraform installed
- local key-pair for AWS CLI access
- needed variables in terraform.tfvars:
    - `bucket_name`: must be globally unique
    - `custom_domain_name`: the desired domain name (eg www.example.com)
    - `referer_header`: a random header string to use for restricting access to S3

Deploy the template with:

```sh
terraform apply
```
