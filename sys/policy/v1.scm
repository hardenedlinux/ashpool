;; This is policy layer for configuring API authorization rules.

(("articles:read"
  (GET "/api/v1/articles"
       "/api/v1/articles/:id"))

 ("articles:write"
  (POST "/api/v1/articles"
        "/api/v1/articles/:id")
  (PUT "/api/v1/articles/:id/publish")
  (DELETE "/api/v1/articles/:id/unpublish"))

 ("users:read"
  (GET "/api/v1/users"
       "/api/v1/users/:id")))
