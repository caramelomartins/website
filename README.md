# hugomartins.io

[![Build Status](https://travis-ci.org/caramelomartins/hugomartins.io.svg?branch=master)](https://travis-ci.org/caramelomartins/hugomartins.io)

This is the source code for my personal website that is currently hosted @ [hugomartins.io](http://hugomartins.io).

I have the website hosted on Github Pages and as such I also use the repo [caramelomartins.github.io](https://github.com/caramelomartins/caramelomartins.github.io) as a hosting system. For such a solution I usually deploy from this repository into the other repository.

I didn't want to have to manage separate branches and git subtrees to do this and wanted to be able to maintain a normal workflow for managing this project. For that I add the necessity to add a separate repository thus this one.

## Structure

This project uses the [Hugo](https://gohugo.io/) static site generator for compiling the source code into the artifacts that are present in the [caramelomartins.github.io](https://github.com/caramelomartins/caramelomartins.github.io) repository.

Most of this is based on Hugo's predefined structure:

- `content` - handles all the fixed and dynamic content.
- `scripts` - holds scripts that help validate and deploy the website.
- `static` - stores static assets.
- `themes` - stores the themes used in the website as git submodules.

## License

[MIT](LICENSE)

