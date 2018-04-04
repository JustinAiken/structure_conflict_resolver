[![Gem Version](http://img.shields.io/gem/v/structure_conflict_resolver.svg)](https://rubygems.org/gems/structure_conflict_resolver)[![Build Status](http://img.shields.io/travis/JustinAiken/structure_conflict_resolver/master.svg)](http://travis-ci.org/JustinAiken/structure_conflict_resolver)[![Coveralls branch](http://img.shields.io/coveralls/JustinAiken/structure_conflict_resolver/master.svg)](https://coveralls.io/r/JustinAiken/structure_conflict_resolver?branch=master)

# Conflict Resolver

Ruby 💎 tool for resolving conflicts in `db/structure.sql`

## Installation

```bash
gem install structure_conflict_resolver
```

You probably won't want to add this to your `Gemfile`, it's more of a CLI tool.

## Usage

When you run into a merge conflict on `db/structure.sql`, give this a try:

```bash
structure_conflict_resolver db/structure.sql
```

It'll smartly resolve any conflicts around the version numbers at the bottom.

Any logical conflicts in the actual table descriptions... you'll have to fix yourself!

## License

MIT
