# ConnectedVehicle_cloudComputing

1. path: /ConnectedVehicle_cloudComputing/terraform/modules/staticwebsite
2. Crear un bucket s3 con el nombre static-website-state para el backend

$terraform init
$terraform apply

1. Ir al bucket s3 --> Subir manualmente el fichero index.html y error.html (por algun motivo no me funciona usando terraform)
2. Ir al bucket s3 --> permissions --> Block public access (bucket settings) settear a OFF  (Permission denied desde Terraform)
3. Ir al punto de distribución creado con CloudFront --> copiar el domain name a un navegador (debería de verse el index.html)
 