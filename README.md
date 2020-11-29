# jibby0/jekyll-webhook

`jibby0/jekyll-webhook` is a fork of [cmrn/jekyll-webhook](https://github.com/cmrn/docker-jekyll-webhook). This fork updates the Ubuntu version + supports Jekyll's newest packaging recommendations.

This is a docker image which:

1. Builds a Jekyll site from source
2. Runs an Nginx server to host the website
3. Creates a GitHub webhook to pull in any new changes to the site

## Basic Usage
### Step 1 - Docker
To start `jibby0/jekyll-webhook` on port 80:

```sh
git clone https://github.com/jibby0/docker-jekyll-webhook
cd docker-jekyll-webhook
docker build -t jibby0/jekyll-webhook .
docker run -d -p 80:80 \ 
           -e REPO="https://github.com/jibby0/blog.git" \ 
           -e WEBHOOK_SECRET="change me" \ 
           jibby0/jekyll-webhook
```

Set `WEBHOOK_SECRET` to variable to a long, random passphrase, and set `REPO` to the clone URL of your GitHub repository.

### Step 2 - GitHub
To set up the webhook in GitHub, go to your repository page, then go to Settings > Webhooks & Services > Add webhook. Set "Payload URL" to your server's address, followed by `/webhook` - for example, `https://jibby.org/webhook`. Set "Secret" to the same value as `WEBHOOK_SECRET`. "Content type" should be "application/json", and the Webhook should only recieve the "push" event.

## Configuration
The image can be given the following configuration values as environment variables:

- `REPO`: Required. The clone URL for your Jekyll repository. If your repository is private, this should also contain a username and password.
- `WEBHOOK_SECRET`: Required. The secret which authenticates genuine requests to the webhook. This should be a long, random secret shared only with GitHub.
- `WEBHOOK_ENDPOINT`: Optional, defaults to `/webhook`. The endpoint for the webhook. Change this if you want to publish something at the URL `/webhook`.
- `BRANCH`: Optional, defaults to `master`. The branch to use from your repository. Another popular value is `gh-pages`, used by GitHub Pages.

### Advanced Configuration

#### NGINX
It's also possible to customise the nginx server configuration by linking in a new `site.conf` template. Save `site.conf` to your host machine, make your changes, and link it into your container:

```sh
docker run -d -p 80:80 \
           -v /path/to/your/site.conf:/site.conf \ 
           -e REPO="https://github.com/jibby0/blog.git" \ 
           -e WEBHOOK_SECRET="change me" \ 
           jibby0/jekyll-webhook
```

#### Updating your Gemfile

To allow for `Gemfile` updates, this image runs `bundle install` with each webhook pull. However, `jekyll` is _not_ restarted, as that means downtime. To update jekyll, update the Gemfile & restart the container.

#### Gem cache

This image overrides your repo's `.bundle/config` to store the `vendor` version in a predictable place. Gems will go in `/vendor`.

To cache installed gems (and speed up redeploys tremendously), use `-v /path/to/your/vendor:/vendor`.

## Credits
This project is a concoction of:

- [Docker](https://www.docker.com/) ([source](https://github.com/docker/docker))
- [Jekyll](http://jekyllrb.com/) ([source](https://github.com/jekyll/jekyll))
- [Nginx](http://wiki.nginx.org/) ([source](http://hg.nginx.org/nginx))
- [github-webhook](https://www.npmjs.com/package/github-webhook) ([source](https://github.com/rvagg/github-webhook))

## License
Permission to use, copy, modify, and/or distribute this software is given under the [ISC license](https://github.com/jibby0/docker-jekyll-webhook/blob/master/LICENSE).
