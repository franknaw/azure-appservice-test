# az login
cd myapp
rm app.zip
zip a -r app.zip *
az webapp deploy --resource-group "Test-RG" --name "fnaw-webapp" --src-path "./app.zip"