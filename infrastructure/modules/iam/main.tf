resource "aws_iam_policy" "tf_state_access" {
  name = "TFStateAccessPolicy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"],
        Effect = "Allow",
        Resource = [
          "arn:aws:s3:::my-tf-state-bucket",
          "arn:aws:s3:::my-tf-state-bucket/*"
        ]
      }
    ]
  })
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_group_policy_attachment" "devops_attach" {
  group      = "DevOps"
  policy_arn = aws_iam_policy.tf_state_access.arn
  lifecycle {
    create_before_destroy = true
  }
}
