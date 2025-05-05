## Client Auth Flow


### Client App Reg 1
* Client App uses this
* Web Redirect URIs
* * https://foo-api.developer.azure-api.net/signin-oauth/implicit/callback
* * https://foo-webapp-dacehzasffe9aca6.eastus2-01.azurewebsites.net
* API Permissions
* * Add Backend-App App Reg Reader - Delegated
* * Add Backend-App App Reg ReaderRole - Application
* foo-c595-4853-8253-d4616e458177 


### Backend App Reg
* Backend Function App uses this
* Web Redirect URIs
* * https://foo-test.azurewebsites.net/api/hello
* * https://foo-test.azurewebsites.net/api/hello/.auth/login/aad/callback
* API Roles ??
* * Add Role for users/groups/applications
* Expose an API
* * Reader - Admin and users
* foo-6072-4b5a-995e-f97f431391e3

### Client App Reg 2
* API Management Service uses this 
* Web Redirect URIs
* * https://foo-api.developer.azure-api.net/signin-oauth/implicit/callback
* * https://foo-api.developer.azure-api.net/signin-oauth/code/callback/oauth-clientflow1
* API Permissions
* * Add Backend-App App Reg - Delegated
* foo-d7c6-4fb9-8b9b-9ae84326eb79
  
### Backend Function App
* Add auth to Backend-App App reg

### API Management Service
* Add Policy
* * This validates the client token
* * This gets and sends a token to the Backend Function App
```XML
<policies>
    <inbound>
        <base />
        <set-backend-service id="apim-generated-policy" backend-id="fnaw-test" />
        <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid.">
            <openid-config url="https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration" />
            <required-claims>
                <claim name="aud">
                    <value>foo-6072-4b5a-995e-f97f431391e3</value>
                </claim>
            </required-claims>
        </validate-jwt>
        <authentication-managed-identity resource="foo-c595-4853-8253-d4616e458177" output-token-variable-name="msi-access-token" ignore-error="false" />
        <set-header name="Authorization" exists-action="override">
            <value>@("Bearer " + (string)context.Variables["msi-access-token"])</value>
        </set-header>
        <cors allow-credentials="true">
            <allowed-origins>
                <origin>https://foo-webapp-dacehzasffe9aca6.eastus2-01.azurewebsites.net</origin>
            </allowed-origins>
            <allowed-methods>
                <method>*</method>
            </allowed-methods>
            <allowed-headers>
                <header>*</header>
            </allowed-headers>
        </cors>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
```
* Add OAuth in developer portal
* * Client reg page url
* * * https://locaolhost
* * Default scope
* * * From Backend App Reg
* * * api://foo-6072-4b5a-995e-f97f431391e3/Reader
* * Client ID
* * * From Client 1 App Reg
* * Redirect URI
* * * Auth grant flow
* * * * https://foo-api.developer.azure-api.net/signin-oauth/code/callback/oauth-clientflow1
* * * Implicit grant flow
* * * * https://foo-api.developer.azure-api.net/signin-oauth/implicit/callback

***

* npm install express-generator -g
* npx express-generator myapp --view=ejs
* npm install
* DEBUG=myapp:* npm start
