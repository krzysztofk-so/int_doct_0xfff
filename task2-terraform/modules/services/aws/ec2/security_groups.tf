resource "aws_security_group" "allow" {
  for_each = {for k, v in var.ec2_map : k => v } #if v["vpc"]["vpc_custom"] == "true"}
  name = "allow-${each.value.ec2_name}"
  vpc_id =  length(local.vpc_to_create_true) > 0 ? aws_vpc.vpc[each.key].id : data.aws_vpc.vpc[each.key].id
  description = "allow"

  tags = merge(var.ec2_map[each.key]["tags"],{
      "Name" = "${var.ec2_map[each.key]["tags"]["project"]}-${var.ec2_map[each.key]["ec2_name"]}"
  })
}

resource "aws_security_group_rule" "allow_rules" {
  for_each = local.map_flatten
  # the split(".", each.key)[0] function splits each.key into two parts by a period (".") and uses the first part (the EC2 instance key). This matches the keys used in aws_security_group.allow.
  security_group_id = aws_security_group.allow[split(".", each.key)[0]].id
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  type              = each.value.type
  cidr_blocks      = try(each.value.cidr_blocks, null)
}
