package envoy.authz

check_constraint(left, operator, right) {
  operator == "acl:operator:hasPart"
  contains(left, right)
}

check_constraint(left, operator, right) {
  operator == "acl:operator:eq"
  left == right
}

check_constraint(left, operator, right) {
  operator == "acl:operator:gt"
  left >= right
}

check_constraint(left, operator, right) {
  operator == "acl:operator:gteq"
  left >= right
}

check_constraint(left, operator, right) {
  operator == "acl:operator:lt"
  left < right
}

check_constraint(left, operator, right) {
  operator == "acl:operator:lteq"
  left <= right
}
