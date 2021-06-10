resource "aws_iam_saml_provider" "default" {
  name                   = "OKTA"
  saml_metadata_document = var.metadata
}

data "aws_iam_policy_document" "okta_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithSAML"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_saml_provider.default.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "SAML:aud"
      values   = ["https://signin.aws.amazon.com/saml"]
    }
  }
}

module "platform_admin_role" {
  source               = "github.com/schubergphilis/terraform-aws-mcaf-role?ref=v0.3.1"
  name                 = var.name
  assume_policy        = data.aws_iam_policy_document.okta_assume_policy.json
  max_session_duration = var.max_session_duration
  policy_arns          = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  postfix              = var.postfix
  tags                 = var.tags
}

data "aws_iam_policy_document" "cross_account_policy" {
  statement {
    actions = [
      "iam:ListRoles",
      "iam:ListAccountAliases"
    ]

    resources = [
      "*"
    ]
  }
}

module "okta_cross_account_role" {
  source                = "github.com/schubergphilis/terraform-aws-mcaf-role?ref=v0.3.1"
  name                  = "Okta-Idp-cross-account-role"
  principal_type        = "AWS"
  principal_identifiers = ["arn:aws:iam::${var.account_id}:root"]
  role_policy           = data.aws_iam_policy_document.cross_account_policy.json
  postfix               = false
  tags                  = var.tags
}
