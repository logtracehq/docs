# Logtrace Documentation

Official documentation for Logtrace.

This repository contains the source code for the Logtrace documentation website, built with **Hugo** and the **Hextra** theme.

## About Logtrace

Logtrace is an open-source audit logging and activity monitoring platform that helps teams track user actions, system events, API requests, and security-related activities across their applications.

The documentation includes:

- Getting Started guides
- Installation and deployment instructions
- SDK documentation
- API reference
- Security and compliance best practices
- Integration tutorials

## Tech Stack

- Hugo
- Hextra Theme
- Markdown
- GitHub Pages (or your preferred hosting platform)

## Prerequisites

Before running the documentation locally, install:

- Hugo Extended (v0.145.0 or later recommended)
- Git

Verify your installation:

```bash
hugo version
```

## Running Locally

Clone the repository:

```bash
git clone https://github.com/logtracehq/docs.git
cd docs
```

Start the Hugo development server:

```bash
hugo server
```

or

```bash
hugo server -p 1315 #to use a different port
```

The site will be available at:

```
http://localhost:1313 # or specified port above
```

To include drafts:

```bash
hugo server -D
```

## Building the Site

Generate a production build:

```bash
hugo
```

The generated static files will be placed in:

```
public/
```

## Repository Structure

```
.
├── content/          # Documentation pages
├── assets/           # Images, styles, and assets
├── layouts/          # Custom layouts (if any)
├── static/           # Static files
├── themes/
│   └── hextra/
├── hugo.yaml
└── README.md
```

## Writing Documentation

Documentation pages are written in Markdown and stored under the `content/` directory.

Example:

```
content/docs/getting-started.md
```

When contributing:

- Use clear and concise language
- Provide practical examples
- Keep code snippets up to date
- Follow the existing documentation structure
- Verify links before submitting changes

## Contributing

Contributions are welcome.

1. Fork the repository
2. Create a branch

```bash
git checkout -b docs/my-improvement
```

3. Make your changes
4. Commit your work

```bash
git commit -m "docs: improve installation guide"
```

5. Push your branch

```bash
git push origin docs/my-improvement
```

6. Open a Pull Request

## Reporting Issues

Found an error or missing documentation?

Please open an issue describing:

- The affected page
- The problem
- Suggested improvements (optional)

## License

This documentation is licensed under the same license as the Logtrace project.
