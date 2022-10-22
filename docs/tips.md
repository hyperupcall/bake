# Tips

Some recommendations for using Bake efficiently

## Conventions

I order my tasks by natural execution order. For example

- `task.init()`
- `task.dev()`
- `task.build()`
- `task.run()`
- `task.serve`
- `task.release()`
- `task.publish()`

When applicable, I have an _idempotent_ `task.init` task for executing right after cloning the repository. If you use [Hookah](https://github.com/hyperupcall/hookah), this is a perfect place to run that

```bash
task.init() {
  hookah refresh
  git submodule update --init --recursive

  pnpm install
}
```

## API Usage

There are no booby traps in the API, so I'll just tell you what I do if you're looking for some _rules_

- Use `bake.assert_not_empty()` whenever positional parameters are accessed. For failing fast with a clear error message

- Use `bake.assert_cmd()` only for commands that are used _after_ another long-running command. Doing this for every external command is too much of a maintenance chore
