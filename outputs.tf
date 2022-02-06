# Output values
#
output "packer-builder-profile-name" {
  value = aws_iam_instance_profile.packer-build.name
}