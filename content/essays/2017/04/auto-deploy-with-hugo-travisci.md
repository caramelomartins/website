---
date: "2017-04-09T17:50:39+01:00"
title: "Automatic Deploys with Hugo, TravisCI & Github Pages"
draft: false
categories:
    - bash
    - continuous integration
    - continuous deployment
---
**tl;dr**

I automated the deployment of this website with Travis CI, Github, Hugo and Github Pages. The website gets build from each push to `master` and, if the build is successful, deployed to Github Pages for website hosting.

## Introduction

A few months ago I wrote an article describing how interesting it can be to automate the deploy workflows - [Automate Simple Deploy Workflows - Cool!](../automate-simple-deploy-workflows---cool/). The easeness of deploying automatically was appealing but it still required some manual work. This is due to the way I wrote the deploy scripts.

During the last few days I've been thinking about better ways to automatically deploy this website, from a repository where its source code is hosted to another repository that serves as a Github Pages' repository.

The initial article I wrote had one lazy script - [deploy-sh](https://github.com/caramelomartins/website/blob/master/scripts/deploy.sh) - that did all the hard work of compiling the website and pushing it to the remote host. That wasn't good enough for me.

When I started thinking about this, I set some goals:

- To only manage one repository. One is enough.
- To not have to insert any credentials when pushing to remote but still use them.
- The build and deployment had to be done for each commit to `master`. This is the only way for the website to be updated.
- It had to be triggered without me doing anything other than pushing the source code to the original repository.

To achieve this goals I used:

- [Hugo](https://gohugo.io/) - still the best static website engine I have tried.
- [Travis CI](https://travis-ci.org/) - to manage the builds.
- [Github](https://github.com) - where the `git` repos are hosted.
- [Github Pages](https://pages.github.com/) - for website hosting.

## Setting Up `deploy.sh`

The initial `deploy.sh` script was as simple as:

```
#!/bin/bash

echo "Building website..."

cd ..
hugo -t cocoa > /dev/null 2>&1
cd "public/" || exit

echo "Copying new website into other repo..."

cp -R ./* ../../caramelomartins.github.io/

echo "Push changes to remote..."

cd "../../caramelomartins.github.io/" || exit
git add -A > /dev/null 2>&1
git commit -m "Push new content" > /dev/null 2>&1
git push > /dev/null 2>&1

echo "Finished deployment..."
```

This was bad for several reasons. The website was built along with deploying it. It needed acess to an environment that was already configured `git`. It didn't provide any information of what commit was deployed.

I decided to revamp this script, from scratch. First I decided to use an environment variable called `GITHUB_API_KEY` to represent a personal token that can be used to push the changes.

We begin by cloning the Github Pages repository:

```
echo "Cloning caramelomartins.github.io..."
git clone -q "https://caramelomartins:$GITHUB_API_KEY@github.com/caramelomartins/caramelomartins.github.io.git"
```

After this is completed, we force the configuration of `git` on Travis CI. This allows me to control who pushes changes from the Travis CI settings' pages.

```
echo "Setting up git configuration..."
git config --global user.email "$GITHUB_EMAIL"
git config --global user.name "$GITHUB_NAME"
git config --global push.default matching
```

`GITHUB_EMAIL` and `GITHUB_NAME` are also environment variables.

We proceed with replacing the contents. First by removing the old contents and then by copying the new content.

```
echo "Removing contents..."
rm -r caramelomartins.github.io/*

echo "Copying new contents..."
cp -r public/* caramelomartins.github.io/
```

This presented a challenge: `CNAME` was replaced in each build. To circunvent this, I added the `CNAME` file to the content of the website. Now, `CNAME` is copied along.

I wanted to know what commit I was deploying from so I added a simple line to this script: `HASH=$(git rev-parse --short HEAD)`. This gives me the commit hash of the latest commit in `HEAD` - this represents the last commit to `master` since Travis CI is configured to only build on `master` commits.

I then push the new contents:

```
echo "Pushing new contents..."
cd caramelomartins.github.io || exit
git add ./*
git commit -q -m "Auto Deploy - $HASH" -m "Built from: https://github.com/caramelomartins/website/commit/$HASH." --allow-empty
git push -q "https://caramelomartins:$GITHUB_API_KEY@github.com/caramelomartins/caramelomartins.github.io.git"
cd ..
```

This provides a beautifully minimalist commit message in every deployment:

```
Auto Deploy - f8154f7
Built from: caramelomartins/website@f8154f7.
```

It tells me what commit was used for deployment, along with an URL to that commit.

After that is done, the script cleans up the assets from the Travis CI environment and exits. The script got 10 lines longer but it became much more effective. You can see the whole script [here](https://github.com/caramelomartins/website/blob/master/scripts/deploy.sh).

## Configuring Github

After the script was done, I had to configure a personal access token. This can be done on the Settings of your Github profile. Under "Developer settings", there's a section called "Personal access tokens".

A personal access token will allow you to authenticate with Github without having to share your credentials. It also allows you to set the exact permissions of your access token.

In this case I only wanted to push to my public repo. That's exactly the only permission I gave to it: `repo.public_repo`.

## Configuring Travis CI

With Travis CI, I just wanted to have it export 3 shell environment variables. The ones I talked initially. So I configured:

- `GITHUB_API_KEY`
- `GITHUB_EMAIL`
- `GITHUB_NAME`

These environment variables which are configured to be hidden from the logs, allow me to push to another repository without disclosing my credentials on Github itself.

## Conclusion

With this solution I reached my initial goals. I now have fully automated deployments from each commit to `master`.

Now that the basics of the deployments are done, adding testing or minimazing assets automatically should be fairly simple to do.
