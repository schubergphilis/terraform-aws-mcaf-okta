resource aws_iam_saml_provider default {
  name                   = "OKTA"
  saml_metadata_document = var.metadata
}

data aws_iam_policy_document default {
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

resource aws_iam_role default {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.default.json
  tags               = var.tags
}

resource aws_iam_role_policy_attachment default {
  role       = aws_iam_role.default.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data aws_iam_policy_document cross_account_role {
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

module okta_cross_account_role {
  source                = "github.com/schubergphilis/terraform-aws-mcaf-role?ref=v0.1.3"
  name                  = "Okta-Idp-cross-account-role"
  principal_type        = "AWS"
  principal_identifiers = ["arn:aws:iam::${var.account_id}:root"]
  role_policy           = data.aws_iam_policy_document.cross_account_role.json
  tags                  = var.tags
}
