<div align="center">

[![Contributors](https://img.shields.io/github/contributors/monobilisim/redmine-issue-tag.svg?style=for-the-badge)](https://github.com/monobilisim/redmine-issue-tag/graphs/contributors)
[![Forks](https://img.shields.io/github/forks/monobilisim/redmine-issue-tag.svg?style=for-the-badge)](https://github.com/monobilisim/redmine-issue-tag/network/members)
[![Stargazers](https://img.shields.io/github/stars/monobilisim/redmine-issue-tag.svg?style=for-the-badge)](https://github.com/monobilisim/redmine-issue-tag/stargazers)
[![Issues](https://img.shields.io/github/issues/monobilisim/redmine-issue-tag.svg?style=for-the-badge)](https://github.com/monobilisim/redmine-issue-tag/issues)
[![GPL License](https://img.shields.io/github/license/monobilisim/redmine-issue-tag.svg?style=for-the-badge)](https://github.com/monobilisim/redmine-issue-tag/blob/master/LICENSE)

[![Readme in English](https://img.shields.io/badge/Readme-English-blue)](https://github.com/monobilisim/redmine-issue-tag/blob/master/README.md)

[![](https://r2.mono.tr/logo/Mono-Logo.svg)](https://mono.net.tr/)

</div>

**redmine-issue-tag** is a Redmine plugin that lists the comments you were mentioned (tagged) in on a single page, with date and project filters. It supports Redmine 5.x and newer.

---

## Table of Contents

* [Table of Contents](#table-of-contents)
* [Features](#features)
* [Filtering & Performance](#filtering--performance)
* [Installation](#installation)
* [Structure](#structure)
* [Usage](#usage)
* [Requirements](#requirements)
* [License](#license)

---

## Features

These features are available in every redmine-issue-tag installation.

* **"Mentioned Comments"** link in the top menu.
* Detects Redmine's native `@login` mention syntax inside journal (comment) bodies.
* Visibility (issue ACL + private notes) is preserved using Redmine's `Journal.visible` logic.
* Mentions inside quotes / code blocks are also counted (for the "where was I tagged" view).

---

## Filtering & Performance

* **Default window: yesterday + today.** It does not scan the entire database on load; only the last 2 days of journals are fetched, keeping the page fast.
* Filter form provides:

  + **Date range** (From / To)
  + **Project** selection
  + **Apply** / **Clear**
* Date and project filters are applied at the SQL level; when criteria are given, only the matching records are fetched.

---

## Installation

```
cp -r redmine_issue_tag /opt/redmine/plugins/
cd /opt/redmine
# (No DB migration required — no table is used)
systemctl restart puma.service   # or your application server
```

---

## Structure

```
redmine-issue-tag/
├── app/
│   ├── controllers/mentions_controller.rb
│   └── views/mentions/index.html.erb
├── config/
│   ├── locales/{tr,en}.yml
│   └── routes.rb
├── lib/redmine_issue_tag/patches/journal_patch.rb
└── init.rb
```

---

## Usage

1. Copy the plugin into your Redmine `plugins/` directory and restart your application server.
2. Once installed, open the **"Mentioned Comments"** link from the top menu.

By default the page shows mentions from yesterday and today. Use the filter form to change the date range or filter by project.

---

## Requirements

* Redmine 5.x or newer

---

## License

redmine-issue-tag is licensed under GPL-3.0. See [LICENSE](https://github.com/monobilisim/redmine-issue-tag/blob/master/LICENSE) file for details.
