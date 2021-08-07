output "dn" {
  value       = aci_rest.fabricLeafP.id
  description = "Distinguished name of `fabricLeafP` object."
}

output "name" {
  value       = aci_rest.fabricLeafP.content.name
  description = "Leaf switch profile name."
}
