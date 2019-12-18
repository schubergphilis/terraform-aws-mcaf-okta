output "assume_policy" {
  value       = data.aws_iam_policy_document.okta_assume_policy.json
  description = "The IAM policy you can attach to roles so they can be assumed by Okta"
}

output "okta_idp_arn" {
  value       = aws_iam_saml_provider.default.arn
  description = "The ARN of the Okta Identity Provider in AWS"
}
