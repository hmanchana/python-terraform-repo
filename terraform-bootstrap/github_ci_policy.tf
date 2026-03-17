resource "aws_iam_policy" "github_ci_policy" {
  name = "github-terraform-ci-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect = "Allow"
            Action = "*"
            Resource = "*"
        }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "github_ci_attach" {
  role = aws_iam_role.github_ci_role.name
  policy_arn = aws_iam_policy.github_ci_policy.arn
}