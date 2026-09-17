## What changed

## Why

## Which of the seven parts

## If this adds or changes a node

- [ ] It states something a good model would **not** already know
- [ ] The always-loaded core is small and the rest is in references. There is no
      enforced ceiling yet, so state the `wc -w` count of any core you changed
      rather than ticking this on judgement alone.
- [ ] It does not restate its parent level
- [ ] No instruction in it appears in another file

## If this adds an instruction an agent will act on

An agent reads these files and acts on them with a filesystem and a shell, so an
instruction is reviewed as code rather than as prose.

- [ ] It never tells an agent to fetch and execute a remote document
- [ ] It never asks an agent to handle a credential, token or password
- [ ] It does not assume a capability the agent may not have without saying so

## Claims

Every statement about what this project does is one of: **implemented and
tested**, **experimental**, **planned**, **unsupported**.

- [ ] Nothing here is described as working that has not been run
