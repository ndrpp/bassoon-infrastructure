# Infrastructure for Astro portofolio written in Terraform

## What this does

- creates an S3 bucket setup for <b>static website hosting</b> with a bucket policy
allowing public read access + a referer header check to restrict direct access 
on the bucket
- creates the cloudfront distribution to act as CDN cache for the static files
hosted in S3 with necessary security headers
- creates a route53 type A record for your domain name to work with cloudfront

## Using this template

Prerequisites:
- terraform installed
- local key-pair for AWS CLI access
- needed variables in terraform.tfvars:
    - `bucket_name`: must be globally unique
    - `custom_domain_name`: the desired domain name (eg www.example.com)
    - `referer_header`: a random header string to use for restricting access to S3
    - `certificate_arn`: the ARN of the certificate from ACM, must match the custom
    domain name and be in <b>us-east-1</b>
    - `r53_zone_id`: the ID of the hosted zone created when successfully requesting
    a R53 domain

Deploy the template with:

```sh
terraform apply
```

## Future improvements

- fully automate deployments using GH Actions by creating an IAM role for the
runner to assume (+secret management)
- enable dnssec on the r53 domain
