# Create an IAM role for the auto-join
resource "aws_iam_role" "auto-join" {
  name               = "kandula-prod-auto-join"
  assume_role_policy = file("../installations/assume-role.json")
}

# Create the policy
resource "aws_iam_policy" "auto-join" {
  name        = "kandula-prod-auto-join"
  #description = "Allows Consul nodes to describe instances for joining."
  policy      = file("../installations/describe-instances.json")
}

# Attach the policy
resource "aws_iam_policy_attachment" "auto-join" {
  name       = "kandula-prod-auto-join"
  roles      = [aws_iam_role.auto-join.name]
  policy_arn = aws_iam_policy.auto-join.arn
}

# Create the instance profile
resource "aws_iam_instance_profile" "auto-join" {
  name  = "kandula-prod-auto-join"
  role = aws_iam_role.auto-join.name
}