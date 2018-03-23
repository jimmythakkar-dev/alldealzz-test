require 'rest-client'

client_id = "6b8ab016d14daaeb01489696134059fb9be417d9c8fbc065407df50c54d3f19a"
client_secret = "3e262453a20ee6c55ff03ad57813bbd0bcba53fdaa914f1bf3db94225e492efc"
response = RestClient.post 'http://localhost:3001/api/oauth/token', {
  grant_type: 'password',
  client_id: client_id,
  client_secret: client_secret,
  username: "aaa",
  password: "bbb"
}

token = JSON.parse(response)["access_token"]

RestClient.get 'http://localhost:3000/api/v1/stores.json', 
{ 'authorization' => "bearer ececb044b1ca201561a6b1b8c46b13568e38c3867063bc8b2a80320495191f0b" }

# http://localhost:3001/api/oauth/token?grant_type=password&client_id=642d7bb7fc4f4857a40b0bcf3bd6b2d87d253826bcf37fff6c784ca01f640c6b&client_secret=3e9e92941eda38b88ed34ed660c5bd19aa62f918bcef2fe92cd97a2d506cb9f7&username=username&password=password
# http://localhost:3001/api/v1/stores.json?Authorization=Bearer e1f7bff94bd9e0cb5cb3b7fdbc3510ae672748c5a3f382e85f2d22d04cdacf22


# client_id = "2717d94d699dfce5fd60444ea8ceb337a05c6cfaf1e94489bf43de3fe1bafc75"
# client_secret = "1dcd105eadcb9b48c72a6331d4f4e7a7698e92ca58c53f32a8fd027b5ba5f740"
# response = RestClient.post 'http://localhost:3000/api/oauth/token', {
#   grant_type: 'client_credentials',
#   client_id: client_id,
#   client_secret: client_secret
# }

# RestClient::Unauthorized: 401 Unauthorized: 
# {"error":"unsupported_grant_type","error_description":"The authorization grant type is not supported by the authorization server."}
