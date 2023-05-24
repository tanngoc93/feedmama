## Code Status

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/tanngoc93/feedmama/tree/main.svg?style=svg&circle-token=f19555d499ff854e21468e846b197d8bba347eba)](https://dl.circleci.com/status-badge/redirect/gh/tanngoc93/feedmama/tree/main) [![codecov](https://codecov.io/gh/tanngoc93/feedmama/branch/main/graph/badge.svg)](https://codecov.io/gh/tanngoc93/feedmama)

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
