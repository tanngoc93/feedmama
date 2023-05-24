## Code Status

[![CircleCI](https://circleci.com/gh/tanngoc93/feedmama.svg?style=shield)](https://circleci.com/gh/tanngoc93/feedmama/tree/main) [![codecov](https://codecov.io/gh/tanngoc93/feedmama/branch/main/graph/badge.svg)](https://codecov.io/gh/tanngoc93/feedmama)

## Clone codebase into your computer & sync all of submodules


```html
git clone ...
```

### Prerequisites

* MySQL
* Redis server
* Ruby version: 3.1.2

* Rails version: 7.0.4
* Docker/Docker Compose

## Note

```
curl -i -X POST "https://graph.facebook.com/[FacebookPageId]/subscribed_apps?subscribed_fields=feed&access_token=[AccessToken]"
curl -i -X GET "https://graph.facebook.com/[FacebookPageId]/subscribed_apps?access_token=[AccessToken]"
curl -i -X POST "https://graph.facebook.com/[InsCommentId]/replies?message=[Message]&access_token=[AccessToken]"
```
