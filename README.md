# Alas

This project is deprecated in favor of [Alas](https://github.com/hackberrydev/alas).

Alas is a system and a tool for planning your days. With Alas, you keep your
plan organized by days in a **single** Markdown file, with the following
structure (today is 2021-07-17):

 ```markdown
# Main TODO

## 2021-07-19, Monday

- [ ] Order the book for Michael
- [ ] Order a new battery for the laptop
- [ ] #work - Review open pull requests
- [ ] #work - Implement two factor authentication backup codes
- [ ] #work - Implement yearly remainder for the backup codes

## 2021-07-18, Sunday

- [ ] Call Kate

## 2021-07-17, Saturday

- [ ] Develop photos
- [X] Pay bills

## 2021-07-16, Friday

- [X] #work - Review open pull requests
- [X] #work - Fix the flaky test


...


## 2017-03-12, Monday

- [X] #work - Create a repository for the new project
- [X] #work - Generate a new Rails project
- [X] #work - Setup a project on NewRelic
- [X] #work - Setup a project on Sentry
 ```

The file serves as a plan for future, but also a log of past.

Run `alas` on your plan file every day before you open the file, to automate
the plan management:

```bash
alas ~/plan.md
```

### Warning

Always keep a backup of your plan file. Alas will edit your plan and you can
loose data in case of a bug or wrong formatting.

One way to keep a backup of the plan file is to put it in a version control
system such as Git.

## Commands

Alas supports the following commands.

#### --help

Show help with all available options:

```bash
alas --help
```

Or:

```bash
alas -h
```

#### --insert-days

By default, `alas` will insert a single new day (today) into your plan. To
insert more than one day, supply the following option:

```bash
alas --insert-days 3 ~/plan.md
```

Or:

```bash
alas -d 3 ~/plan.md
```

## Development

Execute the following command to install dependencies:

```bash
raco pkg install --auto
```

Execute the following command to run tests:

```bash
raco test .
```

## Contributing

Do you want to contribute to the project? Great! Before writing any code, please
get in touch by sending me an email to strika@hackberry.dev.

Feel free to check the list of existing issues or propose new features.
