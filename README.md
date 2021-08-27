# Alas

Alas is a system for planning your days and a tool to help you with that. With
Alas, you keep your plan organized by days in a **single** Markdown file, with
the following structure (today is 2021-07-17):

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
 ```

The file serves as a plan for future, but also a log of past.

Run `alas` on your plan file every day before you open the file, to automate
the plan management:

```bash
alas ~/plan.md
```

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
